import CoreLocation
@testable import GeoLocs

final class MockCLLocationManager: CLLocationManagerProtocol, @unchecked Sendable {

    let mockLocationAuthStatus: CLAuthorizationStatus

    var desiredAccuracy: CLLocationAccuracy
    var distanceFilter: CLLocationDistance
    var delegate: CLLocationManagerDelegate?

    var locationAuthStatus: CLAuthorizationStatus {
        mockLocationAuthStatus
    }

    init(mockLocationAuthStatus: CLAuthorizationStatus) {
        self.mockLocationAuthStatus = mockLocationAuthStatus

        self.desiredAccuracy = kCLLocationAccuracyBest
        self.distanceFilter = kCLDistanceFilterNone
    }

    private(set) var requestWhenInUseAuthorizationWasCalled = false
    private(set) var startUpdatingLocationWasCalled = false
    private(set) var stopUpdatingLocationWasCalled = false
    private(set) var requestLocationWasCalled = false

    func requestWhenInUseAuthorization() {
        requestWhenInUseAuthorizationWasCalled = true
    }

    func startUpdatingLocation() {
        startUpdatingLocationWasCalled = true
    }

    func stopUpdatingLocation() {
        stopUpdatingLocationWasCalled = true
    }

    func requestLocation() {
        requestLocationWasCalled = true
    }
}
