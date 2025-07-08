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
                HStack {
                    VStack(alignment: .leading) {
                        Text(task.title).font(.title3).bold()
                        Text(task.description)
                    }
                    Spacer()
                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                        .frame(width: 35, height: 35)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .foregroundStyle(.white)
        .listRowBackground(EmptyView().background(.ultraThinMaterial).opacity(0.4))
        .listRowInsets(.none)
    }
}
