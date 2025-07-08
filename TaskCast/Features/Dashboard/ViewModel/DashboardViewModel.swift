import Foundation
import SwiftUI
import Combine

protocol DashboardViewModel: ObservableObject {
    var locationName: String { get }
    var temperature: String { get }
    var sunrise: String { get }
    var sunset: String { get }
    var localTime: Date { get }
    var isError: Bool { get set }
    func fetchWeatherData() async
}

class ConcreteDashboardViewModel: ObservableObject, DashboardViewModel {
    @Published var locationName: String = "-"
    @Published var temperature: String = "-"
    @Published var sunrise: String = "--:-- AM"
    @Published var sunset: String = "--:-- PM"
    @Published var localTime: Date = Date()
    @Published var isError: Bool = false
    private var weatherGateway: WeatherGateway
    private var weatherProvider: WeatherProvider
    private var cancellables: Set<AnyCancellable> = []
    
    init(weatherGateway: WeatherGateway,
    weatherProvider: WeatherProvider) {
        self.weatherGateway = weatherGateway
        self.weatherProvider = weatherProvider
        observeWeather()
    }
    
    private func observeWeather() {
        weatherProvider.weatherPublisher.sink { weather in
            withAnimation {
                self.locationName = weather.locationName ?? "-"
                self.temperature = weather.temperature ?? "-"
                self.sunrise = weather.sunrise ?? "-"
                self.sunset = weather.sunset ?? "-"
                self.localTime = weather.localTime ?? Date()
            }
        }.store(in: &cancellables)
    }
    
    @MainActor
    func fetchWeatherData() async {
        let currentWeather = weatherProvider.getWeatherInfo()
        do {
            try await weatherGateway.fetchWeatherData(lat: currentWeather.lat, lon: currentWeather.lon)
        } catch {
            isError = true
        }
    }
}
