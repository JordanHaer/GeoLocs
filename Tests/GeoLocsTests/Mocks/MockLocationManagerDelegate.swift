@testable import GeoLocs

import CoreLocation

final class MockLocationManagerDelegate: NSObject, LocationManagerDelegateProtocol {

    let locationDelegateMethodStream: LocationDelegateMethodStream

    override init() {
        let (locationDelegateMethodStream, _) = AsyncStream.makeStream(of: LocationDelegateMethod.self)
        self.locationDelegateMethodStream = locationDelegateMethodStream
    }
}
