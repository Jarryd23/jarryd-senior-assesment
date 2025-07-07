import SwiftUI

struct TasksListView: View {
    @State var showNewTask: Bool = false
    @ObservedObject var tasksViewModel: ConcreteTasksViewModel
    @State var showListItems = false
    @State var shouldAnimateList = false
    
    init(showNewTask: Bool, tasksViewModel: TasksViewModel) {
        self.tasksViewModel = tasksViewModel as! ConcreteTasksViewModel
        self.showNewTask = showNewTask
    }
    
    var body: some View {
        VStack {
            
            if tasksViewModel.currentTasks.isEmpty {
                EmptyTaskView(showNewTask: $showNewTask)
            } else {
                VStack {
                    ProgressView(value: tasksViewModel.taskProgress)
                        .progressViewStyle(LinearProgressViewStyle(tint: Color.green))
                        .frame(height: 15)
                        .padding(.horizontal, 4)
                    
                    HStack {
                        Text("\(tasksViewModel.currentTasks.filter({ $0.task.isCompleted }).count) Complete").font(.subheadline).bold()
                        Spacer()
                        Text("\(tasksViewModel.currentTasks.filter({ !$0.task.isCompleted }).count) To Do").font(.subheadline).bold()
                    }
                }
                .padding()
                List {
                    if !tasksViewModel.currentTasks.filter({ !$0.task.isCompleted }).isEmpty {
                        todoSection
                    }
                    if !tasksViewModel.currentTasks.filter({ $0.task.isCompleted }).isEmpty {
                        completedSection
                    }
                }
                .toolbar {
                    ToolbarItemGroup {
                        Button {
                            showNewTask.toggle()
                        } label: {
                            Label("New Task", image: "")
                        }
                    }
                }
                .cornerRadius(25, corners: [.topLeft, .topRight])
            }
            
        }
        .animation(.linear, value: shouldAnimateList)
        .tint(Color(uiColor: .orange))
        .navigationTitle("Tasks")
        .sheet(isPresented: $showNewTask, content: {
            NavigationStack {
                NewTaskView(taskTitle: "", taskDescription: "", dueDate: Date(), taskRepository: RootComponent().tasksComponent.taskProvider).navigationTitle("New Task")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarItems(trailing: Button("Cancel") {
                        showNewTask = false
                    })
                    .tint(.orange)
            }
        })
    }
    
    var todoSection: some View {
        Section("To Do") {
            ForEach(Array(tasksViewModel.currentTasks.filter({ !$0.task.isCompleted }).enumerated()), id: \.element.task.id) { index, task in
                ToDoTaskListItem(taskViewModel: task)
            }
            .onDelete { indexSet in
                for index in indexSet {
                    tasksViewModel.deleteTask(with: tasksViewModel.currentTasks.filter({ !$0.task.isCompleted })[index].task.id)
                }
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowBackground(Color.clear)
        }
    }
    
    var completedSection: some View {
        Section("Completed") {
            ForEach(Array(tasksViewModel.currentTasks.filter({ $0.task.isCompleted }).enumerated()), id: \.element.task.id) { index, task in
                CompletedTaskListItem(taskViewModel: task)
                    .swipeActions(allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            tasksViewModel.deleteTask(with: tasksViewModel.currentTasks.filter({ $0.task.isCompleted })[index].task.id)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        .tint(.red)
                        
                        Button {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                                tasksViewModel.currentTasks.filter({ $0.task.isCompleted })[index].toggleCompleted(isComplete: false)
                            }
                        } label: {
                            Label("Move Back", systemImage: "arrowshape.turn.up.backward")
                        }.tint(.indigo)
                    }
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowBackground(Color.clear)
        }
    }
}

struct EmptyTaskView: View {
    @Binding var showNewTask: Bool
    
    var body: some View {
        VStack {
            Image(systemName: "checklist")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text("No Tasks")
                .foregroundColor(.gray)
                .font(.headline)
                .bold()
            TaskButton(buttonText: "Add Task") {
                showNewTask.toggle()
            }.frame(width: 200)
        }
    }
}

struct TaskButton: View {
    var buttonText: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(buttonText)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(uiColor: .orange))
                .cornerRadius(20)
                .shadow(radius: 5)
                .padding()
        }
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(CornerRadiusStyle(radius: radius, corners: corners))
    }
}

struct CornerRadiusStyle: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
