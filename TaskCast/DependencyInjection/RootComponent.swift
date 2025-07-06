import NeedleFoundation
import RealmSwift
import SwiftUI

class RootComponent: BootstrapComponent, ObservableObject {
    
    public var realmAdapter: RealmAdapter {
        shared {
            taskCastRealmAdapter()
        }
    }
    
    public var tasksComponent: TasksComponent {
        TasksComponent(parent: self)
    }
}
