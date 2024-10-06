import CoreLocation

enum LocationDelegateMethod: Sendable {
    case didUpdateLocations(locations: [CLLocation])
    case didFailWithError(error: Error)
    case didChangeAuthorization
}
