import SwiftUI
import Combine

struct TodayTaskView<ViewModel: TodayTaskViewModel>: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        Section("Today's Tasks") {
            if viewModel.tasksDueToday.isEmpty {
                HStack {
                    Spacer()
                    VStack {
                        Text("🎉")
                            .font(.system(size: 32, design: .default))
                        Text("No tasks due today")
                            .font(.title3)
                            .bold()
                        Text("Head over to the task list to add some!")
                    }
                    .multilineTextAlignment(.center)
                    .padding(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0))
                    Spacer()
                }
            }
            ForEach(viewModel.tasksDueToday, id: \.self) { task in
                Text(task.title)
            }
        }
        .scrollContentBackground(.hidden)
        .foregroundStyle(.white)
        .listRowBackground(EmptyView().background(.ultraThinMaterial).opacity(0.4))
        .listRowInsets(.none)
    }
}

#Preview {
    //TodayTaskView()
}

protocol TodayTaskViewModel: ObservableObject {
    var tasksDueToday: [DisplayedTask] { get set }
}

class ConcreteTodayTaskViewModel: ObservableObject, TodayTaskViewModel {
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var tasksDueToday: [DisplayedTask] = []
    private var taskProvider: TaskProvider
    
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

public extension Date {
    func isSame(_ component: Calendar.Component,
                as other: Date,
                calendar: Calendar = .current) -> Bool {
        calendar.isDate(self, equalTo: other, toGranularity: component)
    }
    
    func isSameDay(as other: Date, calendar: Calendar = .current) -> Bool {
        isSame(.day, as: other, calendar: calendar)
    }
}
