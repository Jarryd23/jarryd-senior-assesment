import SwiftUI

public class TaskItemViewModel: ObservableObject {
    @Published var shouldAnimate = false

    let task: DisplayedTask
    private let provider: TaskProvider

    init(task: DisplayedTask, provider: TaskProvider) {
        self.task = task
        self.provider = provider
    }

    func toggleCompleted(isComplete: Bool) {
        shouldAnimate = isComplete
        provider.updateTaskStatus(for: task.id, to: isComplete)
        shouldAnimate = !isComplete
    }
}
