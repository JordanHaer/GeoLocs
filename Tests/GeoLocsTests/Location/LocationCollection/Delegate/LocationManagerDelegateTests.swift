import Testing
@testable import GeoLocs

import CoreLocation

@Suite
struct LocationManagerDelegateTests {

    enum MockCLError: Error, Equatable {
        case mockError
    }

    static private let mockCLLocation: CLLocation = .init(latitude: 0, longitude: 0)

    private let sut: LocationManagerDelegateProtocol
    private let mockLocationDelegateProxy: MockLocationDelegateProxy

    private let mockCLLocationManager: CLLocationManager
    private let oneMillionNanoseconds: UInt64 = 1_000_000_000

    init() {
        let mockLocationDelegateProxy = MockLocationDelegateProxy()

        self.sut = LocationManagerDelegate(locationDelegateProxy: mockLocationDelegateProxy)
        self.mockLocationDelegateProxy = mockLocationDelegateProxy
        self.mockCLLocationManager = CLLocationManager()
    }

    @Test
    func didUpdateLocationsIsCalled() async throws {
        sut.locationManager(mockCLLocationManager, didUpdateLocations: [Self.mockCLLocation])

        try await Task.sleep(nanoseconds: oneMillionNanoseconds)

        let didUpdateLocationsWasCalled = await mockLocationDelegateProxy.didUpdateLocationsWasCalled

        #expect(didUpdateLocationsWasCalled)
    }

    @Test
    func locationPassedToDelegateProxy() async throws {
        sut.locationManager(mockCLLocationManager, didUpdateLocations: [Self.mockCLLocation])

        try await Task.sleep(nanoseconds: oneMillionNanoseconds)

        let optionalLocations = await mockLocationDelegateProxy.locations
        let locations = try #require(optionalLocations)

        #expect(locations == [Self.mockCLLocation])
    }

    @Test
    func didFailWithErrorIsCalled() async throws {
        sut.locationManager(mockCLLocationManager, didFailWithError: MockCLError.mockError)

        try await Task.sleep(nanoseconds: oneMillionNanoseconds)

        let didFailWithErrorWasCalled = await mockLocationDelegateProxy.didFailWithErrorWasCalled

        #expect(didFailWithErrorWasCalled)
    }

    @Test
    func errorPassedToDelegateProxy() async throws {
        sut.locationManager(mockCLLocationManager, didFailWithError: MockCLError.mockError)

        try await Task.sleep(nanoseconds: oneMillionNanoseconds)

        let optionalError = await mockLocationDelegateProxy.error
        let error = try #require(optionalError as? MockCLError)

        #expect(error == MockCLError.mockError)
    }

    @Test
    func didChangeAuthorization() async throws {
        sut.locationManagerDidChangeAuthorization(mockCLLocationManager)

        try await Task.sleep(nanoseconds: oneMillionNanoseconds)

        let didChangeAuthorizationWasCalled = await mockLocationDelegateProxy.didChangeAuthorizationWasCalled

        #expect(didChangeAuthorizationWasCalled)
    }
}
