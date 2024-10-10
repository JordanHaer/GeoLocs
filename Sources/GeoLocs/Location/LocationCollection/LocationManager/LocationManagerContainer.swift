protocol LocationManagerContainerProtocol: Actor {
    func makeLocationManager(locationEventCallback: @escaping LocationEventCallback) async -> LocationManagerProtocol
    func getLocationManager() -> LocationManagerProtocol?
    func setLocationManager(_ locationManager: LocationManagerProtocol)
}

final actor LocationManagerContainer: LocationManagerContainerProtocol {

    private var locationManager: LocationManagerProtocol?

    private let locationManagerFactory: LocationManagerFactoryProtocol

    init(locationManagerFactory: LocationManagerFactoryProtocol) {
        self.locationManagerFactory = locationManagerFactory
    }

    @MainActor
    func makeLocationManager(locationEventCallback: @escaping LocationEventCallback) -> LocationManagerProtocol {
        locationManagerFactory.build(locationEventCallback: locationEventCallback)
    }

    func getLocationManager() -> LocationManagerProtocol? {
        locationManager
    }

    func setLocationManager(_ locationManager: LocationManagerProtocol) {
        self.locationManager = locationManager
    }
}
