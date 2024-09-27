import CoreLocation

public final class MGeo: MGeoProtocol {

    public static let version: String = geoLocsVersion

    private let geoLogger: GeoLoggerProtocol
    private let locationManager: LocationManagerProtocol

    public convenience init(
        logLevel: LogLevel = .release
    ) {
        let dependencies = Self.createMGeoDependencies(logLevel: logLevel)

        self.init(
            geoLogger: dependencies.geoLogger,
            locationManager: dependencies.locationManager
        )
    }

    /// An internal initialiser used for unit and integration testing.
    init(
        geoLogger: GeoLoggerProtocol,
        locationManager: LocationManagerProtocol
    ) {
        self.geoLogger = geoLogger
        self.locationManager = locationManager
    }

    // MARK: Async functions

    public func setup(locationEventCallback: @escaping LocationEventCallback) async -> Bool {
        await locationManager.setLocationEventCallback(locationEventCallback)
        return true
    }

    public func requestLocationAuthStatus() async -> LocationAuthStatus {
        await locationManager.requestLocationAuthStatus()
    }

    public func startUpdatingLocation() async {
        await locationManager.startUpdatingLocation()
    }

    public func stopUpdatingLocation() async {
        await locationManager.stopUpdatingLocation()
    }

    // MARK: Sync functions

    public func setup(
        locationEventCallback: @escaping LocationEventCallback,
        setupFinishedHandler completion: @escaping SetupFinishedCompletion
    ) {
        Task {
            let setupFinished = await setup(locationEventCallback: locationEventCallback)
            completion(setupFinished)
        }
    }

    public func requestLocationAuthStatus(_ completion: @escaping LocationAuthStatusCompletion) {
        Task {
            let locationAuthStatus = await requestLocationAuthStatus()
            completion(locationAuthStatus)
        }
    }

    public func startUpdatingLocation() {
        Task {
            await startUpdatingLocation()
        }
    }

    public func stopUpdatingLocation() {
        Task {
            await stopUpdatingLocation()
        }
    }
}
