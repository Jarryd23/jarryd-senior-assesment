import MapKit

public struct Weather {
    let lat: Double
    let lon: Double
    let locationName: String?
    let localTime: Date?
    let temperature: String?
    let sunrise: String?
    let sunset: String?
    
    init(lat: Double, lon: Double, locationName: String?, localTime: Date?, temperature: String?, sunrise: String?, sunset: String?) {
        self.lat = lat
        self.lon = lon
        self.locationName = locationName
        self.localTime = localTime
        self.temperature = temperature
        self.sunrise = sunrise
        self.sunset = sunset
    }
    
    init(weatherModel: WeatherModel) {
        self.lat = weatherModel.lat
        self.lon = weatherModel.lon
        self.locationName = weatherModel.locationTitle
        self.localTime = weatherModel.localTime
        self.temperature = weatherModel.temperature
        self.sunrise = weatherModel.sunrise
        self.sunset = weatherModel.sunset
    }
}
