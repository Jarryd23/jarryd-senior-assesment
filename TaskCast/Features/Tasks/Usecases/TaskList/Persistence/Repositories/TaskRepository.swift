import Foundation
import Combine
import RealmSwift

public protocol TaskProvider {
    func addTask(task: ToDoTask)
    func getAllTasks() -> [ToDoTask]
    func deleteTask(id: String)
    func updateTaskStatus(for id: String, to completed: Bool)
    func observeTasks()
    var tasksPublisher: AnyPublisher<[ToDoTask], Never> { get }
}

public class TaskRepository: TaskProvider {
    var realmAdapter: RealmAdapter
    let psub = PassthroughSubject<[ToDoTask], Never>()
    private var notificationToken: NotificationToken?
    
    public init(realmAdapter: RealmAdapter) {
        self.realmAdapter = realmAdapter
        observeTasks()
    }

    public func addTask(task: ToDoTask) {
        realmAdapter.write {
            realmAdapter.realm.add(TaskModel(task: task))
        }
    }

    public func getAllTasks() -> [ToDoTask] {
        return realmAdapter.realm.objects(TaskModel.self).map { ToDoTask(taskModel: $0) }
    }

    public func deleteTask(id: String) {
        guard let task = realmAdapter.object(TaskModel.self, forPrimaryKey: id) else { return }
        realmAdapter.write {
            realmAdapter.realm.delete(task)
        }
    }
    
    public func updateTaskStatus(for id: String, to completed: Bool) {
        guard let task = realmAdapter.object(TaskModel.self, forPrimaryKey: id) else { return }
        
        realmAdapter.write {
            task.isCompleted = completed
            realmAdapter.realm.add(task, update: .modified)
        }
    }

    public func observeTasks() {
        let taskRealm = realmAdapter.realm.objects(TaskModel.self)
        notificationToken = taskRealm.observe { [weak self] changes in
            switch changes {
            case .initial, .update:
                let tasks = Array(taskRealm.map { ToDoTask(taskModel: $0) })
                self?.psub.send(tasks)
            case .error(let error):
                print("Realm error: \(error)")
            }
        }
    }
    
    public var tasksPublisher: AnyPublisher<[ToDoTask], Never> {
        return psub.eraseToAnyPublisher()
    }
    
    deinit {
        notificationToken?.invalidate()
    }
}
