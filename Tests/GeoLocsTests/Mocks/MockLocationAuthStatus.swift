@testable import GeoLocs

import CoreLocation

final class MockLocationAuthStatus: LocationAuthStatusProtocol {

    let mockLocationAuthStatus: CLAuthorizationStatus

    var locationAuthStatus: CLAuthorizationStatus {
        mockLocationAuthStatus
    }

    init(mockLocationAuthStatus: CLAuthorizationStatus) {
        self.mockLocationAuthStatus = mockLocationAuthStatus
    }
}
