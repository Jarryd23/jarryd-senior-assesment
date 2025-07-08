import Foundation
import SwiftUI
import CoreLocation
import SimpleToast

protocol OnboardingViewModel: ObservableObject {
    var headerImageName: String { get }
    var title: String { get }
    var subtitle: String { get }
    var description: String { get }
    var primaryCTATitle: String { get }
    var secondaryCTATitle: String { get }
    var primaryAction: () -> Void { get }
    var isError: Bool { get set }
}

public protocol EntityCache {
    associatedtype Entity
    
    func persist(_: Entity)
    func update (_: Entity)
}

class ConcreteOnboardingViewModel: ObservableObject, OnboardingViewModel, MapSelectionDelegate  {
    private var weatherGateway: WeatherGateway
    @AppStorage("hasFinishedOnboarding") var hasFinishedOnboarding: Bool = false
    @Published var isError: Bool = false
    private let locationService = LocationService()
    
    init(weatherGateway: WeatherGateway) {
        self.weatherGateway = weatherGateway
        locationService.onLocationUpdate = { [weak self] coordinate in
                self?.didSelect(coordinate: coordinate)
        }
    }
    
    var headerImageName: String {
        "headerImage"
    }
    
    var title: String {
        "Welcome to TaskCast!"
    }
    
    var subtitle: String {
        "Plan your day from sunrise to sunset"
    }
    
    var description: String {
        "In order to get you the most accurate data, we need your location, or you can choose a location manually."
    }
    
    var primaryCTATitle: String {
        "Use current location"
    }
    
    var secondaryCTATitle: String {
        "Choose location"
    }
    
    var primaryAction: () -> Void {
        {
            self.locationService.requestLocation()
        }
    }
    
    func didSelect(coordinate: CLLocationCoordinate2D) {
        Task {
            do{
                try await weatherGateway.fetchWeatherData(lat: coordinate.latitude, lon: coordinate.longitude)
                
                DispatchQueue.main.async {
                    withAnimation {
                        self.hasFinishedOnboarding = true
                    }
                }
            } catch {
                isError = true
            }
        }
    }
}
