import CoreLocation

protocol LocationManagerDelegateProtocol: CLLocationManagerDelegate, Sendable {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager)
}

final class LocationManagerDelegate: NSObject, LocationManagerDelegateProtocol {

    private let locationDelegateProxy: LocationDelegateProxyProtocol

    init(locationDelegateProxy: LocationDelegateProxyProtocol) {
        self.locationDelegateProxy = locationDelegateProxy
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Task {
            await locationDelegateProxy.perform(.didUpdateLocations(locations: locations))
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task {
            await locationDelegateProxy.perform(.didFailWithError(error: error))
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task {
            await locationDelegateProxy.perform(.didChangeAuthorization)
        }
    }
}
