import SwiftUI

struct ContentView: View {
    @AppStorage("hasFinishedOnboarding") var hasFinishedOnboarding: Bool = false
    var body: some View {
        if hasFinishedOnboarding {
            TabView {
                NavigationStack {
                    DependecyContainer.shared.rootComponent.rootView
                }
                .tabItem {
                    Label("Today",
                          systemImage: "house")
                }
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarBackground(.ultraThinMaterial, for: .tabBar)
                
                
                NavigationStack {
                    DependecyContainer.shared.rootComponent.tasksComponent.rootView
                }
                .tabItem {
                    Label("All Tasks",
                          systemImage: "list.bullet")
                }
            }
            .tint(.orange)
        } else {
            OnboardingView(viewmodel: DependecyContainer.shared.rootComponent.onboardingComponent.onboardingViewModel)
        }
    }
}


import SwiftUI

struct LocationUpdateView: View {
    @State var showMapSelectionView: Bool = false
    var body: some View {
        TaskCastPrimaryButton(buttonText: "Change Location", action: {
            showMapSelectionView.toggle()
        })
        .sheet(isPresented: $showMapSelectionView) {
            RootComponent().mapSelectionView
        }
    }
}
