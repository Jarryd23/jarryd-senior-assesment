

import NeedleFoundation
import RealmSwift
import SwiftUI

// swiftlint:disable unused_declaration
private let needleDependenciesHash : String? = nil

// MARK: - Traversal Helpers

private func parent1(_ component: NeedleFoundation.Scope) -> NeedleFoundation.Scope {
    return component.parent
}

// MARK: - Providers

#if !NEEDLE_DYNAMIC

private class TaskComponentDependenciesd53b7bef8c827695e7b5Provider: TaskComponentDependencies {
    var realmAdapter: RealmAdapter {
        return rootComponent.realmAdapter
    }
    private let rootComponent: RootComponent
    init(rootComponent: RootComponent) {
        self.rootComponent = rootComponent
    }
}
/// ^->RootComponent->TasksComponent
private func factory300b36c36b94ecb3c2e5b3a8f24c1d289f2c0f2e(_ component: NeedleFoundation.Scope) -> AnyObject {
    return TaskComponentDependenciesd53b7bef8c827695e7b5Provider(rootComponent: parent1(component) as! RootComponent)
}
private class WeatherComponentDependenciescb93fc78d7cc2ccc8ba5Provider: WeatherComponentDependencies {
    var realmAdapter: RealmAdapter {
        return rootComponent.realmAdapter
    }
    var networkClient: NetworkClient {
        return rootComponent.networkClient
    }
    private let rootComponent: RootComponent
    init(rootComponent: RootComponent) {
        self.rootComponent = rootComponent
    }
}
/// ^->RootComponent->WeatherComponent
private func factory9f1603ad9e8db7410ca4b3a8f24c1d289f2c0f2e(_ component: NeedleFoundation.Scope) -> AnyObject {
    return WeatherComponentDependenciescb93fc78d7cc2ccc8ba5Provider(rootComponent: parent1(component) as! RootComponent)
}
private class OnboardingComponentDependenciesc2e150944dc3c9e77b26Provider: OnboardingComponentDependencies {
    var realmAdapter: RealmAdapter {
        return rootComponent.realmAdapter
    }
    var networkClient: NetworkClient {
        return rootComponent.networkClient
    }
    var weatherComponent: WeatherComponent {
        return rootComponent.weatherComponent
    }
    private let rootComponent: RootComponent
    init(rootComponent: RootComponent) {
        self.rootComponent = rootComponent
    }
}
/// ^->RootComponent->OnboardingComponent
private func factory269b0df6e85393f6e468b3a8f24c1d289f2c0f2e(_ component: NeedleFoundation.Scope) -> AnyObject {
    return OnboardingComponentDependenciesc2e150944dc3c9e77b26Provider(rootComponent: parent1(component) as! RootComponent)
}

#else
extension TasksComponent: NeedleFoundation.Registration {
    public func registerItems() {
        keyPathToName[\TaskComponentDependencies.realmAdapter] = "realmAdapter-RealmAdapter"
    }
}
extension WeatherComponent: NeedleFoundation.Registration {
    public func registerItems() {
        keyPathToName[\WeatherComponentDependencies.realmAdapter] = "realmAdapter-RealmAdapter"
        keyPathToName[\WeatherComponentDependencies.networkClient] = "networkClient-NetworkClient"
    }
}
extension OnboardingComponent: NeedleFoundation.Registration {
    public func registerItems() {
        keyPathToName[\OnboardingComponentDependencies.realmAdapter] = "realmAdapter-RealmAdapter"
        keyPathToName[\OnboardingComponentDependencies.networkClient] = "networkClient-NetworkClient"
        keyPathToName[\OnboardingComponentDependencies.weatherComponent] = "weatherComponent-WeatherComponent"
    }
}
extension RootComponent: NeedleFoundation.Registration {
    public func registerItems() {

        localTable["realmAdapter-RealmAdapter"] = { [unowned self] in self.realmAdapter as Any }
        localTable["networkClient-NetworkClient"] = { [unowned self] in self.networkClient as Any }
        localTable["tasksComponent-TasksComponent"] = { [unowned self] in self.tasksComponent as Any }
        localTable["weatherComponent-WeatherComponent"] = { [unowned self] in self.weatherComponent as Any }
        localTable["onboardingComponent-OnboardingComponent"] = { [unowned self] in self.onboardingComponent as Any }
        localTable["rootView-some View"] = { [unowned self] in self.rootView as Any }
        localTable["mapSelectionView-some View"] = { [unowned self] in self.mapSelectionView as Any }
        localTable["dashboardViewModel-some DashboardViewModel"] = { [unowned self] in self.dashboardViewModel as Any }
    }
}


#endif

private func factoryEmptyDependencyProvider(_ component: NeedleFoundation.Scope) -> AnyObject {
    return EmptyDependencyProvider(component: component)
}

// MARK: - Registration
private func registerProviderFactory(_ componentPath: String, _ factory: @escaping (NeedleFoundation.Scope) -> AnyObject) {
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: componentPath, factory)
}

#if !NEEDLE_DYNAMIC

@inline(never) private func register1() {
    registerProviderFactory("^->RootComponent->TasksComponent", factory300b36c36b94ecb3c2e5b3a8f24c1d289f2c0f2e)
    registerProviderFactory("^->RootComponent->WeatherComponent", factory9f1603ad9e8db7410ca4b3a8f24c1d289f2c0f2e)
    registerProviderFactory("^->RootComponent->OnboardingComponent", factory269b0df6e85393f6e468b3a8f24c1d289f2c0f2e)
    registerProviderFactory("^->RootComponent", factoryEmptyDependencyProvider)
}
#endif

public func registerProviderFactories() {
#if !NEEDLE_DYNAMIC
    register1()
#endif
}
