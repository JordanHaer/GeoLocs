import Testing
@testable import GeoLocs

import CoreLocation

@Suite
struct LocationManagerTests {

    private let clLocationManager: MockCLLocationManager
    private let locationManagerDelegate: MockLocationManagerDelegate
    private let locationDelegateProxy: MockCLDelegate
    private let mockLocationDelegateProxy: MockLocationDelegateProxy
    private let sut: LocationManager

    init() {
        let cLLocationManager = MockCLLocationManager(mockLocationAuthStatus: .authorizedWhenInUse)
        let locationManagerDelegate = MockLocationManagerDelegate()
        let locationDelegateProxy = MockCLDelegate()
        let mockLocationDelegateProxy = MockLocationDelegateProxy()

        self.clLocationManager = cLLocationManager
        self.locationManagerDelegate = locationManagerDelegate
        self.locationDelegateProxy = locationDelegateProxy
        self.mockLocationDelegateProxy = mockLocationDelegateProxy

        self.sut = LocationManager(
            cLLocationManager: cLLocationManager,
            locationManagerDelegate: locationManagerDelegate,
            locationDelegateProxy: mockLocationDelegateProxy
        )
    }

    @Test
    func requestWhenInUseLocationPermission() async {
        await sut.requestWhenInUseLocationPermission()

        let requestWhenInUseAuthorizationWasCalled = clLocationManager.requestWhenInUseAuthorizationWasCalled

        #expect(requestWhenInUseAuthorizationWasCalled == true)
    }

    @Test
    func requestLocationAuthStatus() async {
        let expectedLocationAuthStatus: LocationAuthStatus = .init(.authorizedWhenInUse)
        let actualLocationAuthStatus = await sut.requestLocationAuthStatus()

        #expect(expectedLocationAuthStatus == actualLocationAuthStatus)
    }

    @Test
    func startUpdatingLocation() async {
        await sut.startUpdatingLocation()

        let startUpdatingLocationWasCalled = clLocationManager.startUpdatingLocationWasCalled

        #expect(startUpdatingLocationWasCalled == true)
    }

    @Test
    func stopUpdatingLocation() async {
        await sut.stopUpdatingLocation()

        let stopUpdatingLocationWasCalled = clLocationManager.stopUpdatingLocationWasCalled

        #expect(stopUpdatingLocationWasCalled == true)
    }
}
