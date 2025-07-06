import Foundation
import RealmSwift

public class TaskModel: Object, TaskCastCachingDomain, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) public var _id: ObjectId
    @Persisted var title: String
    @Persisted var taskDescription: String
    @Persisted var dueDate: Date
    @Persisted var isCompleted: Bool

    public override static func primaryKey() -> String? {
        return "id"
    }

    public convenience init(task: ToDoTask) {
        self.init()
        self._id = try! ObjectId(string: task.id)
        self.title = task.title
        self.taskDescription = task.description
        self.dueDate = task.dueDate
        self.isCompleted = task.isCompleted
    }
}
