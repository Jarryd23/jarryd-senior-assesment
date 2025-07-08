import SwiftUI

@main
struct TaskCastApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class DependecyContainer {
    static let shared = DependecyContainer()
    let rootComponent: RootComponent
    
    private init() {
        rootComponent = RootComponent()
    }
}
