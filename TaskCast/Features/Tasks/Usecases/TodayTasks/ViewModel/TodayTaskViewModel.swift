import Foundation
import Combine

protocol TodayTaskViewModel: ObservableObject {
    var tasksDueToday: [DisplayedTask] { get set }
}

class ConcreteTodayTaskViewModel: ObservableObject, TodayTaskViewModel {
    @Published var tasksDueToday: [DisplayedTask] = []
    private var taskProvider: TaskProvider
    private var cancellables: Set<AnyCancellable> = []
    
    func observeTasks() {
        taskProvider.tasksPublisher.sink { [weak self] tasks in
            self?.tasksDueToday = []
            
            for task in tasks {
                if task.dueDate.isSameDay(as: Date()) {
                    self?.tasksDueToday.append(DisplayedTask(id: task.id, title: task.title, description: task.description, isCompleted: task.isCompleted, dueDate: task.dueDate))
                }
            }
            
        }.store(in: &cancellables)
    }
    
    init(taskProvider: TaskProvider) {
        self.taskProvider = taskProvider
        observeTasks()
    }
}
