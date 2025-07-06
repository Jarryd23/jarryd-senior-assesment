import SwiftUI

struct ToDoTaskListItem: View {
    @StateObject private var vm: TaskItemViewModel
    @Environment(\.colorScheme) private var colorScheme
    private let haptic = UINotificationFeedbackGenerator()

    init(taskViewModel: TaskItemViewModel) {
        _vm = StateObject(wrappedValue: taskViewModel)
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
                    .foregroundColor(Color(uiColor: .purple))
                    .onTapGesture {
                        haptic.notificationOccurred(.success)
                        vm.toggleCompleted(isComplete: true)
                    }

                VStack(alignment: .leading, spacing: 8) {
                    Text(vm.task.title).font(.title2).bold()
                    Text(vm.task.description).fontWeight(.light)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
        }
        .scaleEffect(vm.shouldAnimate ? 0 : 1)
        .opacity(vm.shouldAnimate ? 0 : 1)
    }
}
