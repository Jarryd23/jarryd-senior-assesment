import SwiftUI

struct ToDoTaskListItem: View {
    @StateObject private var taskViewModel: TaskItemViewModel
    @Environment(\.colorScheme) private var colorScheme
    private let haptic = UINotificationFeedbackGenerator()

    init(taskViewModel: TaskItemViewModel) {
        _taskViewModel = StateObject(wrappedValue: taskViewModel)
        haptic.prepare()
    }

    var body: some View {
        ZStack {
            Color(uiColor: colorScheme == .dark
                  ? .secondarySystemGroupedBackground : .white)

            HStack(spacing: 15) {
                Image(systemName: "circle")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color(uiColor: .orange))
                    .onTapGesture {
                        haptic.notificationOccurred(.success)
                        taskViewModel.toggleCompleted(isComplete: true)
                    }

                VStack(alignment: .leading, spacing: 8) {
                    Text(taskViewModel.task.title).font(.title2).bold()
                    Text(taskViewModel.task.description).fontWeight(.light)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
        }
    }
}
