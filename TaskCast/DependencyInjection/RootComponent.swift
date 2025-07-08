import NeedleFoundation
import RealmSwift
import SwiftUI

class RootComponent: BootstrapComponent, ObservableObject {
    public var realmAdapter: RealmAdapter {
        shared {
            taskCastRealmAdapter()
        }
    }
    
    public var networkClient: NetworkClient {
        shared {
            ConcreteNetworkClient()
        }
    }
    
    public var tasksComponent: TasksComponent {
        TasksComponent(parent: self)
    }
    
    public var weatherComponent: WeatherComponent {
        WeatherComponent(parent: self)
    }
    
    public var onboardingComponent: OnboardingComponent {
        OnboardingComponent(parent: self)
    }
    
    public var rootView: some View {
        DashboardView(viewModel: dashboardViewModel, taskView: tasksComponent.todayTaskView)
    }
    
    public var mapSelectionView: some View {
        MapView(delegate: onboardingComponent.onboardingViewModel as? MapSelectionDelegate)
    }
    
    public var dashboardViewModel: some DashboardViewModel {
        ConcreteDashboardViewModel(weatherGateway: weatherComponent.weatherGateway, weatherProvider: weatherComponent.weatherProvider)
    }
}
