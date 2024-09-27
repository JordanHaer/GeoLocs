import Testing
@testable import GeoLocs

@Suite
struct MGeoTests {

    static private let oneMillionNanoseconds: UInt64 = 1_000_000_000

    private let sut: MGeo
    private let mockLocationManager: MockLocationManager

    init() {
        let geoLogger = GeoLogger(logLevel: .debug)
        let mockLocationManager = MockLocationManager()

        self.sut = .init(
            geoLogger: geoLogger,
            locationManager: mockLocationManager
        )

        self.mockLocationManager = mockLocationManager
    }

    // MARK: Async Tests

    @Test
    func WhenAsyncSetupIsCalled_ThenLocationManagerSetupIsCalled() async {
        let locationEventCallback: LocationEventCallback = { _ in }

        let setupFinished = await sut.setup(locationEventCallback: locationEventCallback)

        #expect(setupFinished == true)

        let setLocationEventCallbackWasCalled = await mockLocationManager.setLocationEventCallbackWasCalled
        #expect(setLocationEventCallbackWasCalled)
    }

    @Test
    func WhenAsyncRequestLocationAuthStatusIsCalled_ThenLocationManagerRequestLocationAuthStatusIsCalled() async {
        let expectedLocationAuthStatus: LocationAuthStatus = .notDetermined

        let actualLocationAuthStatus = await sut.requestLocationAuthStatus()

        #expect(expectedLocationAuthStatus == actualLocationAuthStatus)

        let requestLocationAuthStatusWasCalled = await mockLocationManager.requestLocationAuthStatusWasCalled
        #expect(requestLocationAuthStatusWasCalled)
    }

    @Test
    func WhenAsyncStartUpdatingLocationIsCalled_ThenLocationManagerStartUpdatingLocationIsCalled() async {
        await sut.startUpdatingLocation()

        let startUpdatingLocationWasCalled = await mockLocationManager.startUpdatingLocationWasCalled
        #expect(startUpdatingLocationWasCalled)
    }

    @Test
    func WhenAsyncStopUpdatingLocationIsCalled_ThenLocationManagerStopUpdatingLocationIsCalled() async {
        await sut.stopUpdatingLocation()

        let stopUpdatingLocationWasCalled = await mockLocationManager.stopUpdatingLocationWasCalled
        #expect(stopUpdatingLocationWasCalled)
    }

    // MARK: Sync Tests

    @Test
    func WhenSyncSetupIsCalled_ThenLocationManagerSetupIsCalled() throws {
        let locationEventCallback: LocationEventCallback = { _ in }

        sut.setup(locationEventCallback: locationEventCallback) { setupFinished in
            #expect(setupFinished == true)
        }

        Task {
            try await Task.sleep(nanoseconds: Self.oneMillionNanoseconds)
            let setLocationEventCallbackWasCalled = await mockLocationManager.setLocationEventCallbackWasCalled
            #expect(setLocationEventCallbackWasCalled)
        }
    }

    @Test
    func WhenSyncRequestLocationAuthStatusIsCalled_ThenLocationManagerRequestLocationAuthStatusIsCalled() throws {
        let expectedLocationAuthStatus: LocationAuthStatus = .notDetermined

        sut.requestLocationAuthStatus { actualLocationAuthStatus in
            #expect(expectedLocationAuthStatus == actualLocationAuthStatus)
        }

        Task {
            try await Task.sleep(nanoseconds: Self.oneMillionNanoseconds)
            let requestLocationAuthStatusWasCalled = await mockLocationManager.requestLocationAuthStatusWasCalled
            #expect(requestLocationAuthStatusWasCalled)
        }
    }

    @Test
    func WhenSyncStartUpdatingLocationIsCalled_ThenLocationManagerStartUpdatingLocationIsCalled() throws {
        sut.startUpdatingLocation()

        Task {
            try await Task.sleep(nanoseconds: Self.oneMillionNanoseconds)
            let startUpdatingLocationWasCalled = await mockLocationManager.startUpdatingLocationWasCalled
            #expect(startUpdatingLocationWasCalled)
        }
    }

    @Test
    func WhenSyncStopUpdatingLocationIsCalled_ThenLocationManagerStopUpdatingLocationIsCalled() throws {
        sut.stopUpdatingLocation()

        Task {
            try await Task.sleep(nanoseconds: Self.oneMillionNanoseconds)
            let stopUpdatingLocationWasCalled = await mockLocationManager.stopUpdatingLocationWasCalled
            #expect(stopUpdatingLocationWasCalled)
        }
    }
}
