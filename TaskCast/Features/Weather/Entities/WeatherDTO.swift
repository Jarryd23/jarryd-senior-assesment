struct WeatherDTO: Decodable {
    let current: Current
    let location: Location
    let forecast: ForecastContainer
    
    struct Current: Decodable {
        let temp_c: Double
    }
    
    struct Location: Decodable {
        let name: String
        let localtime: String
    }
    
    struct Forecast: Decodable {
        let astro: AstroDTO
    }
    
    struct AstroDTO: Decodable {
        let sunrise: String
        let sunset: String
    }
    
    struct ForecastContainer: Decodable {
        let forecastday: [Forecast]
    }
}
