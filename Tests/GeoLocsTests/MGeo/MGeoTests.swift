import Testing
@testable import GeoLocs

@Suite
struct MGeoTests {

    private let sut: MGeo
    private let mockLocationManager: MockLocationManager
    private let locationEventCallback: LocationEventCallback = { _ in }

    init() async {
        let mockLocationManager = MockLocationManager()

        let geoLogger = MockGeoLogger(logLevel: .debug)
        let mockLocationManagerFactory = await MockLocationManagerFactory(locationManager: mockLocationManager)
        let locationManagerContainer = LocationManagerContainer(locationManagerFactory: mockLocationManagerFactory)

        self.sut = .init(
            geoLogger: geoLogger,
            locationManagerContainer: locationManagerContainer
        )
        self.mockLocationManager = mockLocationManager
    }

    // MARK: Async Tests

    @Test
    func WhenAsyncSetupIsCalled_ThenLocationManagerSetupIsCalled() async {
        await #expect(throws: Never.self) {
            try await sut.setup(locationEventCallback: locationEventCallback)
        }

        let requestWhenInUseLocationPermissionWasCalled = await mockLocationManager.requestWhenInUseLocationPermissionWasCalled
        #expect(requestWhenInUseLocationPermissionWasCalled)
    }

    @Test
    func WhenAsyncSetupIsCalledTwice_ThenErrorIsThrownOnSecondcall() async {
        await #expect(throws: Never.self) {
            try await sut.setup(locationEventCallback: locationEventCallback)
        }

        await #expect(throws: MGeoError.setupAlreadyCalled) {
            try await sut.setup(locationEventCallback: locationEventCallback)
        }
    }

    @Test
    func GivenSetupIsCalled_WhenAsyncRequestLocationAuthStatusIsCalled_ThenLocationManagerRequestLocationAuthStatusIsCalled() async throws {
        try await sut.setup(locationEventCallback: locationEventCallback)

        let expectedLocationAuthStatus: LocationAuthStatus = .notDetermined

        let actualLocationAuthStatus = try await sut.requestLocationAuthStatus()

        #expect(expectedLocationAuthStatus == actualLocationAuthStatus)

        let requestLocationAuthStatusWasCalled = await mockLocationManager.requestLocationAuthStatusWasCalled
        #expect(requestLocationAuthStatusWasCalled)
    }

    @Test
    func GivenSetupIsCalled_WhenAsyncStartUpdatingLocationIsCalled_ThenLocationManagerStartUpdatingLocationIsCalled() async throws {
        try await sut.setup(locationEventCallback: locationEventCallback)

        try await sut.startUpdatingLocation()

        let startUpdatingLocationWasCalled = await mockLocationManager.startUpdatingLocationWasCalled
        #expect(startUpdatingLocationWasCalled)
    }

    @Test
    func GivenSetupIsCalled_WhenAsyncStopUpdatingLocationIsCalled_ThenLocationManagerStopUpdatingLocationIsCalled() async throws {
        try await sut.setup(locationEventCallback: locationEventCallback)

        try await sut.stopUpdatingLocation()

        let stopUpdatingLocationWasCalled = await mockLocationManager.stopUpdatingLocationWasCalled
        #expect(stopUpdatingLocationWasCalled)
    }

    @Test
    func GivenSetupIsNotYetCalled_WhenAsyncRequestLocationAuthStatusIsCalled_ThenErrorIsThrown() async {
        await #expect(throws: MGeoError.setupNotCalledYet) {
            try await sut.requestLocationAuthStatus()
        }

        let requestLocationAuthStatusWasCalled = await mockLocationManager.requestLocationAuthStatusWasCalled
        #expect(requestLocationAuthStatusWasCalled == false)
    }

    @Test
    func GivenSetupIsNotYetCalled_WhenAsyncStartUpdatingLocationIsCalled_ThenErrorIsThrown() async {
        await #expect(throws: MGeoError.setupNotCalledYet) {
            try await sut.startUpdatingLocation()
        }

        let startUpdatingLocationWasCalled = await mockLocationManager.startUpdatingLocationWasCalled
        #expect(startUpdatingLocationWasCalled == false)
    }

    @Test
    func GivenSetupIsNotYetCalled_WhenAsyncStopUpdatingLocationIsCalled_ThenErrorIsThrown() async {
        await #expect(throws: MGeoError.setupNotCalledYet) {
            try await sut.stopUpdatingLocation()
        }

        let stopUpdatingLocationWasCalled = await mockLocationManager.stopUpdatingLocationWasCalled
        #expect(stopUpdatingLocationWasCalled ==  false)
    }
}
