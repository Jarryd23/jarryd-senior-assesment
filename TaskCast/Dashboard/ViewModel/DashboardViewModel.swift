import Foundation
import SwiftUI

protocol DashboardViewModel: ObservableObject {
    var locationName: String { get }
    var temperature: String { get }
    var sunrise: String { get }
    var sunset: String { get }
    var solarPosition: Double { get }
    func fetchWeatherData() async
}

class ConcreteDashboardViewModel: ObservableObject, DashboardViewModel {
    @Published var locationName: String = "-"
    @Published var temperature: String = "-°C"
    @Published var sunrise: String = "--:-- AM"
    @Published var sunset: String = "--:-- PM"
    @Published var solarPosition: Double = 0
    private var weatherGateway: WeatherGateway
    
    init(weatherGateway: WeatherGateway) {
        self.weatherGateway = weatherGateway
    }
    
    @MainActor
    func fetchWeatherData() async {
        Task {
            do {
                let data = try await weatherGateway.fetchWeatherData(lat: 53, lon: -0.12)
                withAnimation {
                    locationName = data.name
                    temperature = String(format: "%.1f°C", data.temperature)
                    sunrise = data.sunrise
                    sunset = data.sunset
                }
            } catch {
                print("Failed:", error)
            }
        }
    }
}
