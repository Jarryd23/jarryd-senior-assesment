import Foundation
import Combine
import SwiftUI

public protocol TasksViewModel: ObservableObject {
    var currentTasks: [TaskItemViewModel] { get set }
    var taskProgress: Double { get }
    func deleteTask(with id: String)
    func updateTaskStatus(with id: String, isCompleted: Bool)
}

public class ConcreteTasksViewModel: TasksViewModel, ObservableObject {
    @Published public var currentTasks: [TaskItemViewModel] = []
    @Published public var taskProgress: Double = 0.0
    private var taskProvider: TaskProvider
    private var cancellables: Set<AnyCancellable> = []
    
    public init(taskprovider: TaskProvider) {
        self.taskProvider = taskprovider
        observeTasks()
    }
    
    func observeTasks() {
        taskProvider.tasksPublisher.sink { [weak self] tasks in
            withAnimation {
            self?.currentTasks = []
            
            for task in tasks {
                guard let taskProvider = self?.taskProvider else { continue }
                
                self?.currentTasks.append(TaskItemViewModel(task: DisplayedTask(id: task.id, title: task.title, description: task.description, isCompleted: task.isCompleted, dueDate: task.dueDate), provider: taskProvider))
            }
            
            
                self?.taskProgress = Double(self?.currentTasks.count == 0 ? 0 : Double(self?.currentTasks.filter({$0.task.isCompleted}).count ?? 0) / Double(self?.currentTasks.count ?? 1))
            }
            
        }.store(in: &cancellables)
    }
    
    public func deleteTask(with id: String) {
        taskProvider.deleteTask(id: id)
    }
    
    public func updateTaskStatus(with id: String, isCompleted: Bool) {
        taskProvider.updateTaskStatus(for: id, to: isCompleted)
    }
}

public struct DisplayedTask: Hashable {
    var id: String
    var title: String
    var description: String
    var isCompleted: Bool
    var dueDate: Date
}
