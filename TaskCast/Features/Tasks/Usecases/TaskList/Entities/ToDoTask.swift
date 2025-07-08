import Foundation
import RealmSwift
import Realm

public class ToDoTask {
    var id: String
    var title: String
    var description: String
    var dueDate: Date
    var isCompleted: Bool

    init(id: String, title: String, description: String, dueDate: Date, isCompleted: Bool) {
        self.id = id
        self.title = title
        self.description = description
        self.dueDate = dueDate
        self.isCompleted = isCompleted
    }

    public init(taskModel: TaskModel) {
        self.id = taskModel._id.stringValue
        self.title = taskModel.title
        self.description = taskModel.taskDescription
        self.dueDate = taskModel.dueDate
        self.isCompleted = taskModel.isCompleted
    }
}

