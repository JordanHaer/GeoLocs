import Testing
@testable import GeoLocs

@Suite
struct LocationManagerContainerTests {

    private let sut: LocationManagerContainer
    private let mockLocationManager: MockLocationManager

    init() {
        let mockLocationManager = MockLocationManager()
        let mockLocationManagerFactory = MockLocationManagerFactory(locationManager: mockLocationManager)
        self.sut = .init(locationManagerFactory: mockLocationManagerFactory)
        self.mockLocationManager = mockLocationManager
    }

    @Test
    func foo1() async {
        let locationEventCallback: LocationEventCallback = { _ in }
        let actualLocationManager = await sut.makeLocationManager(locationEventCallback: locationEventCallback)

        #expect(actualLocationManager === mockLocationManager)
    }

    @Test
    func foo2() async {
        let actualLocationManager = await sut.getLocationManager()

        #expect(actualLocationManager == nil)
    }

    @Test
    func foo3() async {
        let expectedLocationManager = MockLocationManager()
        await sut.setLocationManager(expectedLocationManager)
        let actualLocationManager = await sut.getLocationManager()

        #expect(actualLocationManager === actualLocationManager)
    }
}
