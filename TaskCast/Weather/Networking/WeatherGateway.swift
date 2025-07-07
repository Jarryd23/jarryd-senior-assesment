struct Weather {
    let name: String
    let temperature: Double
    let sunrise: String
    let sunset: String
}

protocol WeatherGateway {
    func fetchWeatherData(lat: Double, lon: Double) async throws -> Weather
}

final class ConcreteWeatherGateway: WeatherGateway {
    private let api: WeatherAPI
    
    init(api: WeatherAPI) {
        self.api = api
    }
    
    func fetchWeatherData(lat: Double, lon: Double) async throws -> Weather {
        let dto = try await api.fetchCurrentWeatherDTO(lat: lat, lon: lon)
        return Weather(name: dto.location.name,
                       temperature: dto.current.temp_c,
                       sunrise: dto.forecast.forecastday.first?.astro.sunrise ?? "",
                       sunset: dto.forecast.forecastday.first?.astro.sunset ?? "")
    }
}
