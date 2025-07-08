import Foundation
import RealmSwift
import SwiftUI

struct NewTaskView: View, TaskValidatable {
    var taskValidationRules: [any Rule] = [EmptyTaskRule()]
    var taskRepository: TaskProvider
    @State var taskTitle: String = ""
    @State var taskDescription: String = ""
    @State var dueDate: Date = Date()
    @State var isError: Bool = false
    @State var errorMessage: String = ""
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isTextEditorFocused: Bool
    
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
                                    isTextEditorFocused = false
                                }
                            }
                        }
                }
                Section {
                    DatePicker("Due Date", selection: $dueDate, in: Date()...(.distantFuture), displayedComponents: [.date])
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                }
            }
            TaskCastPrimaryButton(buttonText: "Add Task") {
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
    
    private func validate() -> Bool {
        let taskRule = taskValidationRules.filter({$0.validate(value: [taskTitle])}).first
        
        if taskRule != nil {
            errorMessage = taskRule?.errorMessage() ?? ""
            isError = true
            return false
        }
        
        return true
    }
}


