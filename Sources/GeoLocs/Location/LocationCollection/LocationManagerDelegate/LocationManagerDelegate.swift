import CoreLocation

protocol CLDelegate: CLLocationManagerDelegate, Sendable {}

protocol LocationManagerDelegateProtocol: CLDelegate {
    var locationDelegateMethodStream: LocationDelegateMethodStream { get }
}

final class LocationManagerDelegate: NSObject, LocationManagerDelegateProtocol {

    let locationDelegateMethodStream: LocationDelegateMethodStream

    private let continuation: LocationDelegateMethodContinuation

    init(
        locationDelegateMethodStream: LocationDelegateMethodStream,
        continuation: LocationDelegateMethodContinuation
    ) {
        self.locationDelegateMethodStream = locationDelegateMethodStream
        self.continuation = continuation
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        continuation.yield(.didUpdateLocations(locations: locations))
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        continuation.yield(.didFailWithError(error: error))
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        continuation.yield(.didChangeAuthorization)
    }
}
