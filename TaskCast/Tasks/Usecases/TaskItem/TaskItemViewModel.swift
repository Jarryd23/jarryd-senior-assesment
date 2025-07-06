import SwiftUI

protocol TaskProviding {
    func updateTaskStatus(for id: String, to completed: Bool)
}

public class TaskItemViewModel: ObservableObject {
    @Published var shouldAnimate = false

    let task: DisplayedTask
    private let provider: TaskProvider

    init(task: DisplayedTask, provider: TaskProvider) {
        self.task      = task
        self.provider  = provider
    }

    func toggleCompleted(isComplete: Bool) {
        shouldAnimate = true

        provider.updateTaskStatus(for: task.id, to: isComplete)
        shouldAnimate = false  
    }
}
