import Foundation

protocol WeatherGateway {
    func fetchWeatherData(lat: Double, lon: Double) async throws
}

final class ConcreteWeatherGateway<Cache: EntityCache>: WeatherGateway where Cache.Entity == Weather {
    private let api: WeatherAPI
    let cache: Cache
    
    init(api: WeatherAPI,
         cache: Cache) {
        self.api = api
        self.cache = cache
    }
    
    func fetchWeatherData(lat: Double, lon: Double) async throws {
        do {
            let dto = try await api.fetchCurrentWeatherDTO(lat: lat, lon: lon)
            cache.persist(Weather(lat: lat,
                                  lon: lon,
                                  locationName: dto.location.name,
                                  localTime: dateFromString(dto.location.localtime),
                                  temperature: String(dto.current.temp_c),
                                  sunrise: dto.forecast.forecastday.first?.astro.sunrise ?? "",
                                  sunset: dto.forecast.forecastday.first?.astro.sunset ?? ""))
        } catch {
            throw error
        }
    }
    
    private func dateFromString(
        _ string: String,
        timeZone: TimeZone = .init(secondsFromGMT: 0) ?? .current
    ) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        formatter.timeZone = timeZone
        return formatter.date(from: string)
    }
}


