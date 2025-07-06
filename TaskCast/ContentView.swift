import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DashboardView()
                
                .tabItem {
                    Label("Today",
                          systemImage: "house")
                }
                
            Text("Tab 2")
                .tabItem {
                    Label("All Tasks",
                          systemImage: "list.bullet")
                }
        }
    }
}
