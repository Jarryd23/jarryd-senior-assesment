import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DashboardView()
                
                .tabItem {
                    Label("Today",
                          systemImage: "house")
                }
                
            NavigationStack {
                RootComponent().tasksComponent.rootView
                    .tabItem {
                        Label("All Tasks",
                              systemImage: "list.bullet")
                    }
            }
        }
    }
}
