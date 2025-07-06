import SwiftUI

struct CurrentTaskView: View {
    var body: some View {
        ZStack(alignment: .top) {
            List {
                Text("Hello World")
                Text("Hello World")
                Text("Hello World")
            }
            .scrollContentBackground(.hidden)
            
            
        }
    }
}

#Preview {
    CurrentTaskView()
}

