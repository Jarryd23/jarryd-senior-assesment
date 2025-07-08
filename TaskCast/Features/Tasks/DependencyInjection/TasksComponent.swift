import NeedleFoundation
import RealmSwift
import SwiftUI

protocol TaskComponentDependencies: Dependency {
    var realmAdapter: RealmAdapter { get }
}
class TasksComponent: Component<TaskComponentDependencies>{
    
    public var rootView: some View {
        TasksListView(showNewTask: false, tasksViewModel: tasksviewModel)
    }
    
    public var todayTaskView: some View {
        TodayTaskView(viewModel: todayTaskViewModel)
    }
    
    public var todayTaskViewModel: some TodayTaskViewModel {
        ConcreteTodayTaskViewModel(taskProvider: taskProvider)
    }
    
    public var tasksviewModel: some TasksViewModel {
        ConcreteTasksViewModel(taskprovider: taskProvider)
    }
    
    public var taskProvider: TaskProvider {
        TaskRepository(realmAdapter: dependency.realmAdapter)
    }
}
