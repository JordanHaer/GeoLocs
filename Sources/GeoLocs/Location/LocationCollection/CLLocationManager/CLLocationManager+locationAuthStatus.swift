import CoreLocation

extension CLLocationManager: @unchecked @retroactive Sendable, CLLocationManagerProtocol {
    var locationAuthStatus: CLAuthorizationStatus {
        self.authorizationStatus
    }
}
