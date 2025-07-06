import Foundation
import RealmSwift
import os.log

public typealias RealmDecodable = Object & Decodable

@objc public protocol TaskCastCachingDomain {}


func getConfiguration(fileName: String, objectTypes: [Object.Type]) -> Realm.Configuration {
    var configuration = Realm.Configuration.defaultConfiguration
    configuration.fileURL = configuration.fileURL?.deletingLastPathComponent().appendingPathComponent(fileName)
    configuration.objectTypes = objectTypes
    return configuration
}

public class RealmAdapter {
    private let name: String
    private var configuration: Realm.Configuration

    public init(name: String, configuration: Realm.Configuration) {
        self.name = name
        self.configuration = configuration
        initializeRealm()
    }

    private func initializeRealm() {
        do {
            _ = try Realm(configuration: configuration)
        } catch let error {
            os_log("Cannot create realm, attempting to delete: %@", log: .default, type: .debug, error.localizedDescription)
            // The only reason this should fail really is if we can't decrypt an existing realm because the encryption key changed.
            // Our only recourse is to delete the Realm, and retry the configuration.
            // THIS SHOULD ONLY BE DONE ON APP LAUNCH, BEFORE ANY OTHER REALM ACCESSES
            deleteRealm()
        }
    }

    public var realm: Realm {
        return try! Realm(configuration: configuration)
    }

    public func clearRealm() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch let error {
            os_log("Error clearing the Realm: %@", log: .default, type: .debug, error.localizedDescription)
        }
    }

    public func deleteRealm() {
        guard let realmURL = configuration.fileURL else {
            return
        }

        let urls: [URL] = [realmURL,
                           realmURL.appendingPathExtension("lock"),
                           realmURL.appendingPathExtension("note"),
                           realmURL.appendingPathExtension("management")]
        urls.forEach { url in
            do {
                try FileManager.default.removeItem(at: url)
            } catch let error {
                os_log("Error deleting realm file at $@. %@", log: .default, type: .debug, url.absoluteString, error.localizedDescription)
            }
        }
    }

    public func objects<T: Object>(_ type: T.Type) -> [T] {
        return Array(realm.objects(type))
    }

    public func objects<T: Object>(_ type: T.Type, sortedBy key: String, ascending: Bool = true) -> [T] {
        return Array(realm.objects(type).sorted(byKeyPath: key, ascending: ascending))
    }

    public func objects<T: Object>(_ type: T.Type, filteredBy filter: String, _ args: Any...) -> [T] {
        return Array(realm.objects(type).filter(filter, args))
    }

    public func object<T: Object>(_ type: T.Type) -> T? {
        return objects(type).first
    }
    
    public func object<T: Object, KeyType>(_ type: T.Type, forPrimaryKey primaryKey: KeyType) -> T? {
        if let objectIDKey = try? ObjectId(string: primaryKey as! String) {
            return realm.object(ofType: type, forPrimaryKey: objectIDKey)
        } else {
            return realm.object(ofType: type, forPrimaryKey: primaryKey)
        }
    }

    public func write<Result>(updates: (() throws -> Result)) {
        try! realm.write {
            try! updates()
        }
    }

    public func update(deletions: [AnyClass] = [], insertions: [AnyObject] = []) throws {
        try transaction { realm in
            let deletions = deletions.compactMap {
                $0 as? Object.Type
            }
            let insertions = insertions.compactMap {
                $0 as? Object
            }
            deletions.forEach {
                realm.delete(realm.objects($0))
            }
            realm.add(insertions)
        }
    }

    private func transaction(block: ((Realm) throws -> Void)) throws {
        do {
            let realm = self.realm
            realm.beginWrite()
            do {
                try block(realm)
            } catch {
                if realm.isInWriteTransaction {
                    realm.cancelWrite()
                }
                throw error
            }
            if realm.isInWriteTransaction {
                try realm.commitWrite()
            }
        } catch let error {
            os_log("Unable to commit write transaction: %@", log: .default, type: .debug, error.localizedDescription)
            throw error
        }
    }
}

public func taskCastRealmAdapter() -> RealmAdapter {
    var configuration = getConfiguration(fileName: "TaskCast.realm", objectTypes: subscribers(of: TaskCastCachingDomain.Type.self).compactMap {
        $0.classObject as? Object.Type
    })
    configuration.schemaVersion = 2 // This needs to be bumped whenever we change the database
    configuration.migrationBlock = { _, _ in }  // We don't need to do any migration this time around
    return RealmAdapter(name: "TaskCast", configuration: configuration)
}
