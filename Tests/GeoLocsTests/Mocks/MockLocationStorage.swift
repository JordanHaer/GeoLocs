@testable import GeoLocs

final actor MockLocationStorage: LocationStorageAddProtocol {

    private(set) var addWasCalled = false
    private(set) var latestLocationEvent: LocationEvent?
    private(set) var numberOfLocations = 0

    func add(_ locationEvent: LocationEvent) {
        addWasCalled = true
        latestLocationEvent = locationEvent
        numberOfLocations += 1
    }
}
