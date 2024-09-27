import CoreLocation

protocol CLLocationManagerProtocol: LocationAuthStatusProtocol {
    var desiredAccuracy: CLLocationAccuracy { get set }
    var distanceFilter: CLLocationDistance { get set }
    var delegate: CLLocationManagerDelegate? { get set }

    func requestWhenInUseAuthorization()
    func startUpdatingLocation()
    func stopUpdatingLocation()
}

protocol LocationAuthStatusProtocol: Sendable {
    var locationAuthStatus: CLAuthorizationStatus { get }
}

extension CLLocationManager: @unchecked @retroactive Sendable, CLLocationManagerProtocol {
    var locationAuthStatus: CLAuthorizationStatus {
        self.authorizationStatus
    }
}
