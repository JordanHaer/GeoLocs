import Testing
@testable import GeoLocs

@Suite
struct LocationDelegateProxyTests: Sendable {

    private enum MockCLError: Error {
        case mockError
    }

    @Test
    func performDidUpdateLocations() async {
        let expectedLocationEvent: LocationEvent = .valid(.init(latitude: 0, longitude: 0, locationType: .async))

        let sut = makeLocationDelegateProxy(expectedLocationEvent: expectedLocationEvent)

        await sut.perform(.didUpdateLocations(locations: [.init(latitude: 0, longitude: 0)]))
    }

    @Test
    func performDidUpdateLocationsNoLocations() async {
        let expectedLocationEvent: LocationEvent = .invalid(.locationUnavailable)

        let sut = makeLocationDelegateProxy(expectedLocationEvent: expectedLocationEvent)

        await sut.perform(.didUpdateLocations(locations: []))
    }

    @Test
    func performDidFailWithError() async {
        let expectedLocationEvent: LocationEvent = .invalid(.locationUnavailable)

        let sut = makeLocationDelegateProxy(expectedLocationEvent: expectedLocationEvent)

        await sut.perform(.didFailWithError(error: MockCLError.mockError))
    }

    @Test
    func performDidChangeAuthorization() async {
        let expectedLocationEvent: LocationEvent = .permission(.authorizedWhenInUse)

        let sut = makeLocationDelegateProxy(expectedLocationEvent: expectedLocationEvent)

        await sut.perform(.didChangeAuthorization)
    }

    private func makeLocationDelegateProxy(expectedLocationEvent: LocationEvent) -> LocationDelegateProxy {
        let mockLocationStorage = MockLocationStorage()
        let mockCLLocationManager = MockLocationAuthStatus(mockLocationAuthStatus: .authorizedWhenInUse)
        let locationEventCallback: LocationEventCallback = { locationEvent in
            #expect(expectedLocationEvent == locationEvent)
        }

        return .init(
            locationStorage: mockLocationStorage,
            cLLocationManager: mockCLLocationManager,
            locationEventCallback: locationEventCallback
        )
    }
}
