import CoreLocation
@testable import GeoLocs

final class MockLocationAuthStatus: LocationAuthStatusProtocol {

    let mockLocationAuthStatus: CLAuthorizationStatus

    var locationAuthStatus: CLAuthorizationStatus {
        mockLocationAuthStatus
    }

    init(mockLocationAuthStatus: CLAuthorizationStatus) {
        self.mockLocationAuthStatus = mockLocationAuthStatus
    }
}
