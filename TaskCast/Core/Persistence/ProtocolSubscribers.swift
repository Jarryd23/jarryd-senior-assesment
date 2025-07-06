import Foundation
import RealmSwift

public func subscribers<T>(of: T.Type) -> [ClassInfo] {
    var subscribersList = [ClassInfo]()

    var count = UInt32(0)
    let classListPointer = objc_copyClassList(&count)!

    let classList = UnsafeBufferPointer(start: classListPointer, count: Int(count))

    for i in 0..<Int(count) {
        if let classInfo = ClassInfo(classList[i]) {
            
            if classInfo.moduleAndClassName.components(separatedBy: ".").count == 1 {
                continue
            }

            if classInfo.classObject is T {
                subscribersList.append(classInfo)
            }
        }
    }

    return subscribersList
}

public struct ClassInfo: CustomStringConvertible, Equatable {
    public let classObject: AnyClass
    let moduleAndClassName: String

    init?(_ classObject: AnyClass?) {
        guard classObject != nil else {
            return nil
        }

        self.classObject = classObject!
        let cName = class_getName(classObject)
        self.moduleAndClassName = String(cString: cName)
    }

    var superclassInfo: ClassInfo? {
        let superclassObject: AnyClass? = class_getSuperclass(self.classObject)
        return ClassInfo(superclassObject)
    }

    public var description: String {
        return self.moduleAndClassName
    }

    var className: String {
        return self.moduleAndClassName.components(separatedBy: ".").last ?? self.moduleAndClassName
    }

    public static func ==(lhs: ClassInfo, rhs: ClassInfo) -> Bool {
        return lhs.moduleAndClassName == rhs.moduleAndClassName
    }
}
