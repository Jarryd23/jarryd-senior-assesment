import SwiftUI

struct CompletedTaskListItem: View {
    var taskViewModel: TaskItemViewModel
    @State private var shouldAnimate = false
    
    @Environment(\.colorScheme) private var colorScheme
    
    init(taskViewModel: TaskItemViewModel) {
        self.taskViewModel = taskViewModel
    }
    
    var body: some View {
        ZStack {
            Color(uiColor: colorScheme == .dark ? .secondarySystemGroupedBackground : .white)
            
            HStack(spacing: 15){
                Button {
                    
                } label: {
                    Image(systemName: "checkmark.circle.fill").resizable().frame(width: 30, height: 30)
                        .foregroundColor(Color(uiColor: .purple))
                }
                VStack(alignment: .leading, spacing: 8){
                    Text(taskViewModel.task.title).font(.title2).bold().strikethrough()
                    Text(taskViewModel.task.description).fontWeight(.light).strikethrough()
                }.frame(maxWidth: .infinity, alignment: .leading)
            }.onAppear {
                withAnimation {
                    shouldAnimate = true
                }
            }.padding()
        }.scaleEffect(shouldAnimate ? 1 : 0, anchor: .center)
            .opacity(shouldAnimate ? 1 : 0)
    }
}

//struct CompletedTaskListItem_Previews: PreviewProvider {
//    static var previews: some View {
//        CompletedTaskListItem()
//    }
//}
