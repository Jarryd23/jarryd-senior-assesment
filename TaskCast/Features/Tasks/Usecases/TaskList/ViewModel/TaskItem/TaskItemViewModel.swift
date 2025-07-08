import SwiftUI

public class TaskItemViewModel: ObservableObject {
    let task: DisplayedTask
    private let provider: TaskProvider

    init(task: DisplayedTask, provider: TaskProvider) {
        self.task = task
        self.provider = provider
    }

    func toggleCompleted(isComplete: Bool) {
        withAnimation {
            provider.updateTaskStatus(for: task.id, to: isComplete)
        }
    }
}
