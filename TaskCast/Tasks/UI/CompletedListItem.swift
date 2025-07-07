import SwiftUI

struct CompletedTaskListItem: View {
    @StateObject var taskViewModel: TaskItemViewModel
    @State private var shouldAnimate = false
    
    @Environment(\.colorScheme) private var colorScheme
    
    init(taskViewModel: TaskItemViewModel) {
        _taskViewModel = StateObject(wrappedValue: taskViewModel)
    }
    
    var body: some View {
        ZStack {
            Color(uiColor: colorScheme == .dark ? .secondarySystemGroupedBackground : .white)
            
            HStack(spacing: 15){
                Button {
                    
                } label: {
                    Image(systemName: "checkmark.circle.fill").resizable().frame(width: 30, height: 30)
                        .foregroundColor(Color(uiColor: .orange))
                }
                VStack(alignment: .leading, spacing: 8){
                    Text(taskViewModel.task.title).font(.title2).bold().strikethrough()
                    Text(taskViewModel.task.description).fontWeight(.light).strikethrough()
                }.frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
        }
    }
}
