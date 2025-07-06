

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

#else
extension TasksComponent: NeedleFoundation.Registration {
    public func registerItems() {
        keyPathToName[\TaskComponentDependencies.realmAdapter] = "realmAdapter-RealmAdapter"
    }
}
extension RootComponent: NeedleFoundation.Registration {
    public func registerItems() {

        localTable["realmAdapter-RealmAdapter"] = { [unowned self] in self.realmAdapter as Any }
        localTable["tasksComponent-TasksComponent"] = { [unowned self] in self.tasksComponent as Any }
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
    registerProviderFactory("^->RootComponent", factoryEmptyDependencyProvider)
}
#endif

public func registerProviderFactories() {
#if !NEEDLE_DYNAMIC
    register1()
#endif
}
