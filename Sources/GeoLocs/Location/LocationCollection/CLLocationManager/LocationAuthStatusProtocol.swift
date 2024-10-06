import CoreLocation

protocol LocationAuthStatusProtocol: Sendable {
    var locationAuthStatus: CLAuthorizationStatus { get }
}
