import Foundation
import RealmSwift
import SwiftUI

struct NewTaskView: View, TaskValidatable {
    var taskValidationRules: [any Rule] = [EmptyTaskRule()]
    
    @State var taskTitle: String
    @State var taskDescription: String = ""
    @State var dueDate: Date = Date()
    @State var isError: Bool = false
    @State var errorMessage: String = ""
    @Environment(\.dismiss) private var dismiss
    var taskRepository: TaskProvider
    @FocusState private var isTextEditorFocused: Bool
    
    private func validate() -> Bool {
        let taskRule = taskValidationRules.filter({$0.validate(value: [taskTitle])}).first
        
        if taskRule != nil {
            errorMessage = taskRule?.errorMessage() ?? ""
            isError = true
            return false
        }
        
        return true
    }
    
    var body: some View {
        VStack {
            List {
                Section("Task Details") {
                    TextField("Task Title", text: $taskTitle)
                        .font(.largeTitle).bold()
                        .submitLabel(.done)
                    TextEditor(text: $taskDescription)
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                        .frame(height: 200)
                        .focused($isTextEditorFocused)
                                        .toolbar {
                                            ToolbarItemGroup(placement: .keyboard) {
                                                Spacer()
                                                Button("Done") {
                                                    isTextEditorFocused = false // Dismiss the keyboard
                                                }
                                            }
                                        }
                }
                Section {
                    DatePicker("Due Date", selection: $dueDate, in: Date()...(.distantFuture), displayedComponents: [.date])
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                }
            }
            TaskButton(buttonText: "Add Task") {
                if validate() {
                    taskRepository.addTask(task: ToDoTask(id: ObjectId.generate().stringValue, title: taskTitle, description: taskDescription, dueDate: dueDate, isCompleted: false))
                    dismiss()
                }
            }
        }
        .ignoresSafeArea(.keyboard).background(Color(uiColor: .systemGroupedBackground))
        .alert(errorMessage, isPresented: $isError) {
            Button("OK", action: {
                isError = false
            })
        }
    }
}

//struct NewTaskView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewTaskView(taskTitle: "Science Homework", taskDescription: "hgfahjefakhjsfvashjfvshjfjhfjhfjhdjdiewijdsjfdljglaiufglwieUFGleuiwf", dueDate: Date())
//    }
//}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct EmptyTaskRule: Rule {
    func validate(value: [String]) -> Bool {
        for text in value {
            if text.isEmpty {
                return true
            }
        }
        return false
    }
    
    func errorMessage() -> String {
        "Please enter a valid task title"
    }
}
