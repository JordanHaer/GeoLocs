import CoreLocation

public final class MGeo: MGeoProtocol {

    public static let version: String = "0.0.4"

    private let geoLogger: GeoLoggerProtocol
    private let locationManagerContainer: LocationManagerContainerProtocol

    public convenience init(logLevel: LogLevel = .release) {
        let geoLogger = GeoLogger(logLevel: logLevel)
        let locationManagerFactory = LocationManagerFactory()
        let locationManagerContainer = LocationManagerContainer(locationManagerFactory: locationManagerFactory)

        self.init(
            geoLogger: geoLogger,
            locationManagerContainer: locationManagerContainer
        )
    }

    /// An internal initialiser used for unit and integration testing.
    init(
        geoLogger: GeoLoggerProtocol,
        locationManagerContainer: LocationManagerContainerProtocol
    ) {
        self.geoLogger = geoLogger
        self.locationManagerContainer = locationManagerContainer
    }

    public func setup(locationEventCallback: @escaping LocationEventCallback) async throws(MGeoError) {
        guard
            await locationManagerContainer.getLocationManager() == nil
        else {
            throw .setupAlreadyCalled
        }

        let locationManager = await locationManagerContainer.makeLocationManager(
            locationEventCallback: locationEventCallback
        )
        await locationManager.requestWhenInUseLocationPermission()
        await setLocationManager(locationManager)
    }

    public func requestLocationAuthStatus() async throws(MGeoError) -> LocationAuthStatus {
        let locationManager = try await unwrapLocationManager()
        return await locationManager.requestLocationAuthStatus()
    }

    public func startUpdatingLocation() async throws(MGeoError) {
        let locationManager = try await unwrapLocationManager()
        await locationManager.startUpdatingLocation()
    }

    public func stopUpdatingLocation() async throws(MGeoError) {
        let locationManager = try await unwrapLocationManager()
        await locationManager.stopUpdatingLocation()
    }

    private func setLocationManager(_ locationManager: LocationManagerProtocol) async {
        await locationManagerContainer.setLocationManager(locationManager)
    }

    private func unwrapLocationManager() async throws(MGeoError) -> LocationManagerProtocol {
        guard
            let locationManager = await locationManagerContainer.getLocationManager()
        else {
            throw .setupNotCalledYet
        }

        return locationManager
    }
}
