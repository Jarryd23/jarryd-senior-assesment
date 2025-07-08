import CoreLocation

final class LocationService: NSObject, CLLocationManagerDelegate, ObservableObject {
    private let manager = CLLocationManager()
    var onLocationUpdate: ((CLLocationCoordinate2D) -> Void)?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    func requestLocation() {
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        onLocationUpdate?(location.coordinate)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location:", error.localizedDescription)
    }
}
