import Foundation
import Combine
import RealmSwift

public protocol WeatherProvider {
    var weatherPublisher: AnyPublisher<Weather, Never> { get }
    func getWeatherInfo() -> Weather
}

public class WeatherRepository: WeatherProvider, EntityCache {
    public typealias Entity = Weather
    
    private let realmAdapter: RealmAdapter
    private var notificationToken: NotificationToken?
    private let psub = PassthroughSubject<Weather, Never>()
    
    public init(realmAdapter: RealmAdapter) {
        self.realmAdapter = realmAdapter
        observeWeather()
    }
    public func persist(_ weatherObject: Weather) {
        try! realmAdapter.update(deletions: [WeatherModel.self], insertions: [WeatherModel(weatherObject: weatherObject)])
    }
    
    public func update(_ weatherObject: Weather) {
        try! realmAdapter.update(deletions: [], insertions: [WeatherModel(weatherObject: weatherObject)])
    }
    
    public func getWeatherInfo() -> Weather {
        let model = realmAdapter.object(WeatherModel.self)
        return Weather(weatherModel: model!)
    }

    public func observeWeather() {
        let weatherRealm = realmAdapter.realm.objects(WeatherModel.self)
        notificationToken = weatherRealm.observe { [weak self] changes in
            switch changes {
            case .initial, .update:
                let model = weatherRealm.map({ Weather(lat: $0.lat,
                                                       lon: $0.lon,
                                                       locationName: $0.locationTitle,
                                                       localTime: $0.localTime,
                                                       temperature: $0.temperature,
                                                       sunrise: $0.sunrise,
                                                       sunset: $0.sunset) }).first
                if let model {
                    self?.psub.send(model)
                }
            case .error(let error):
                print("Realm error: \(error)")
            }
        }
    }
    
    public var weatherPublisher: AnyPublisher<Weather, Never> {
        return psub.eraseToAnyPublisher()
    }
    
    deinit {
        notificationToken?.invalidate()
    }
}
