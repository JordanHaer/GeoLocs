import Testing
@testable import GeoLocs

@Suite
struct LocationDelegateProxyTests {

    enum MockCLError: Error {
        case mockError
    }

    private var sut: LocationDelegateProxyProtocol

    init() {
        let mockLocationStorage = MockLocationStorage()
        let mockCLLocationManager = MockLocationAuthStatus(mockLocationAuthStatus: .authorizedWhenInUse)

        self.sut = LocationDelegateProxy(
            locationStorage: mockLocationStorage,
            cLLocationManager: mockCLLocationManager
        )
    }

    @Test
    mutating func performDidUpdateLocations() async {
        let expectedLocationEvent: LocationEvent = .valid(.init(latitude: 0, longitude: 0, locationType: .async))

        await sut.setLocationEventCallback { actualLocationEvent in
            #expect(expectedLocationEvent == actualLocationEvent)
        }

        await sut.perform(.didUpdateLocations(locations: [.init(latitude: 0, longitude: 0)]))
    }

    @Test
    mutating func performDidUpdateLocationsNoLocations() async {
        let expectedLocationEvent: LocationEvent = .invalid(.locationUnavailable)

        await sut.setLocationEventCallback { actualLocationEvent in
            #expect(expectedLocationEvent == actualLocationEvent)
        }

        await sut.perform(.didUpdateLocations(locations: []))
    }

    @Test
    mutating func performDidFailWithError() async {
        let expectedLocationEvent: LocationEvent = .invalid(.locationUnavailable)

        await sut.setLocationEventCallback { actualLocationEvent in
            #expect(expectedLocationEvent == actualLocationEvent)
        }

        await sut.perform(.didFailWithError(error: MockCLError.mockError))
    }

    @Test
    mutating func performDidChangeAuthorization() async {
        let expectedLocationEvent: LocationEvent = .permission(.authorizedWhenInUse)

        await sut.setLocationEventCallback { actualLocationEvent in
            #expect(expectedLocationEvent == actualLocationEvent)
        }

        await sut.perform(.didChangeAuthorization)
    }
}
