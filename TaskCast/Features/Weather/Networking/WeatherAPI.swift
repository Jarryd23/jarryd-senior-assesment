import Foundation

protocol WeatherAPI {
    func fetchCurrentWeatherDTO(lat: Double, lon: Double) async throws -> WeatherDTO
}

struct ConcreteWeatherAPI: WeatherAPI {
    private let network: NetworkClient
    private let baseURL: URL
    private let apiKey:  String
    
    init(baseURL: URL,
         apiKey: String,
         network: NetworkClient) {
        self.baseURL = baseURL
        self.apiKey  = apiKey
        self.network = network
    }
    
    func fetchCurrentWeatherDTO(lat: Double, lon: Double) async throws -> WeatherDTO {
        var components = URLComponents(url: baseURL.appendingPathComponent("/forecast.json"),
                                       resolvingAgainstBaseURL: false)!
        components.queryItems = [
            .init(name: "key", value: apiKey),
            .init(name: "days", value: "1"),
            .init(name: "q", value: "\(lat),\(lon)")
        ]
        
        let request = URLRequest(url: components.url!)
        return try await network.request(request)
    }
}
