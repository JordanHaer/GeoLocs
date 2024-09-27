@testable import GeoLocs

final actor MockLocationManager: LocationManagerProtocol {

    private(set) var setLocationEventCallbackWasCalled = false
    private(set) var requestWhenInUseLocationPermissionWasCalled = false
    private(set) var requestLocationAuthStatusWasCalled = false
    private(set) var startUpdatingLocationWasCalled = false
    private(set) var stopUpdatingLocationWasCalled = false

    func setLocationEventCallback(_ locationEventCallback: @escaping LocationEventCallback) {
        setLocationEventCallbackWasCalled = true
    }

    func requestWhenInUseLocationPermission() {
        requestLocationAuthStatusWasCalled = true
    }

    func requestLocationAuthStatus() -> LocationAuthStatus {
        requestLocationAuthStatusWasCalled = true
        return .notDetermined
    }

    func startUpdatingLocation() {
        startUpdatingLocationWasCalled = true
    }

    func stopUpdatingLocation() {
        stopUpdatingLocationWasCalled = true
    }
}
