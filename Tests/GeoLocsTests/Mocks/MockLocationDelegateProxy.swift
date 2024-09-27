@testable import GeoLocs

import CoreLocation

final actor MockLocationDelegateProxy: LocationDelegateProxyProtocol {

    private(set) var didUpdateLocationsWasCalled = false
    private(set) var locations: [CLLocation]?

    private(set) var didFailWithErrorWasCalled = false
    private(set) var error: Error?

    private(set) var didChangeAuthorizationWasCalled = false

    private(set) var setLocationEventCallbackWasCalled = false

    func perform(_ method: LocationDelegateMethod) {
        switch method {
        case .didUpdateLocations(let locations):
            didUpdateLocationsWasCalled = true
            self.locations = locations
        case .didFailWithError(let error):
            didFailWithErrorWasCalled = true
            self.error = error
        case .didChangeAuthorization:
            didChangeAuthorizationWasCalled = true
        }
    }

    func setLocationEventCallback(_ locationEventCallback: @escaping LocationEventCallback) {
        setLocationEventCallbackWasCalled = true
    }
}
