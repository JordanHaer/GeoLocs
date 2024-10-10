import Testing
@testable import GeoLocs

import CoreLocation

@Suite
struct LocationDelegateProxyTests: Sendable {

    private enum MockCLError: Error {
        case mockError
    }

    private let locationManagerDelegate: LocationManagerDelegate
    private let continuation: LocationDelegateMethodContinuation

    init() {
        let (locationDelegateMethodStream, continuation) = AsyncStream.makeStream(of: LocationDelegateMethod.self)
        self.locationManagerDelegate = .init(
            locationDelegateMethodStream: locationDelegateMethodStream,
            continuation: continuation
        )
        self.continuation = continuation
    }

    @Test
    func performDidUpdateLocations() async {
        let expectedLocationEvent: LocationEvent = .valid(.init(latitude: 0, longitude: 0, locationType: .async))

        let sut = makeLocationDelegateProxy(expectedLocationEvent: expectedLocationEvent)

        continuation.yield(.didUpdateLocations(locations: [.init(latitude: 0, longitude: 0)]))
        await sut.listenForLocationManagerDelegate()
    }

    @Test
    func performDidUpdateLocationsNoLocations() async {
        let expectedLocationEvent: LocationEvent = .invalid(.locationUnavailable)

        let sut = makeLocationDelegateProxy(expectedLocationEvent: expectedLocationEvent)

        continuation.yield(.didUpdateLocations(locations: []))
        await sut.listenForLocationManagerDelegate()
    }

    @Test
    func performDidFailWithError() async {
        let expectedLocationEvent: LocationEvent = .invalid(.locationUnavailable)

        let sut = makeLocationDelegateProxy(expectedLocationEvent: expectedLocationEvent)

        continuation.yield(.didFailWithError(error: MockCLError.mockError))
        await sut.listenForLocationManagerDelegate()
    }

    @Test
    func performDidChangeAuthorization() async {
        let expectedLocationEvent: LocationEvent = .permission(.authorizedWhenInUse)

        let sut = makeLocationDelegateProxy(expectedLocationEvent: expectedLocationEvent)

        continuation.yield(.didChangeAuthorization)
        await sut.listenForLocationManagerDelegate()
    }

    private func makeLocationDelegateProxy(expectedLocationEvent: LocationEvent) -> LocationDelegateProxy {
        let mockLocationStorage = MockLocationStorage()
        let mockCLLocationManager = MockLocationAuthStatus(mockLocationAuthStatus: .authorizedWhenInUse)

        let locationEventCallback: LocationEventCallback = { locationEvent in
            #expect(expectedLocationEvent == locationEvent)
            continuation.finish()
        }

        return .init(
            locationStorage: mockLocationStorage,
            cLLocationManager: mockCLLocationManager,
            locationManagerDelegate: locationManagerDelegate,
            locationEventCallback: locationEventCallback
        )
    }
}
