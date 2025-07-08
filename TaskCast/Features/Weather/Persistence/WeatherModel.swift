import Foundation
import RealmSwift

public class WeatherModel: Object, TaskCastCachingDomain, ObjectKeyIdentifiable {
    @Persisted var lon: Double
    @Persisted var lat: Double
    @Persisted var locationTitle: String?
    @Persisted var localTime: Date?
    @Persisted var temperature: String?
    @Persisted var sunrise: String?
    @Persisted var sunset: String?

    public convenience init(weatherObject: Weather) {
        self.init()
        self.lon = weatherObject.lon
        self.lat = weatherObject.lat
        self.locationTitle = weatherObject.locationName
        self.localTime = weatherObject.localTime
        self.temperature = weatherObject.temperature
        self.sunrise = weatherObject.sunrise
        self.sunset = weatherObject.sunset
    }
}
