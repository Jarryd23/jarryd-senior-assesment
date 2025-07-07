import NeedleFoundation
import RealmSwift
import SwiftUI

protocol WeatherComponentDependencies: Dependency {
    var realmAdapter: RealmAdapter { get }
    var networkClient: NetworkClient { get }
}
class WeatherComponent: Component<WeatherComponentDependencies>{
    
    public var weatherGateway: WeatherGateway {
        ConcreteWeatherGateway(api: weatherApi)
    }
    
    public var weatherApi: WeatherAPI {
        let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String
        
        return ConcreteWeatherAPI(baseURL: URL(string: "https://api.weatherapi.com/v1")!,
                                  apiKey: apiKey ?? "",
                                  network: dependency.networkClient)
    }
    
    public var taskProvider: TaskProvider {
        TaskRepository(realmAdapter: dependency.realmAdapter)
    }
}
