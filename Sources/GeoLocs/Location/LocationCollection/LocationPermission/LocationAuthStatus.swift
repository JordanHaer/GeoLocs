import CoreLocation

@frozen
public enum LocationAuthStatus: Sendable {

    case notDetermined
    case denied
    case authorizedAlways
    case authorizedWhenInUse
    case unknown

    init(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            self = .notDetermined
        case .denied, .restricted:
            self = .denied
        case .authorizedAlways:
            self = .authorizedAlways
        case .authorizedWhenInUse:
            self = .authorizedWhenInUse
        @unknown default:
            self = .unknown
        }
    }
}
