import NeedleFoundation
import RealmSwift
import SwiftUI

protocol OnboardingComponentDependencies: Dependency {
    var realmAdapter: RealmAdapter { get }
    var networkClient: NetworkClient { get }
    var weatherComponent: WeatherComponent { get }
}

class OnboardingComponent: Component<OnboardingComponentDependencies>{
    public var weatherGateway: WeatherGateway {
        dependency.weatherComponent.weatherGateway
    }
    
    public var onboardingViewModel: some OnboardingViewModel {
        ConcreteOnboardingViewModel(weatherGateway: weatherGateway)
    }
}
