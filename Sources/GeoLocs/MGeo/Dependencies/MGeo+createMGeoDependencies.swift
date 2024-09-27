import CoreLocation

extension MGeo {
    static func createMGeoDependencies(logLevel: LogLevel) -> MGeoDependencies {
        let geoLogger = GeoLogger(logLevel: logLevel)

        let locationStorage = LocationStorage()
        let cLLocationManager = CLLocationManager()

        let locationDelegateProxy = LocationDelegateProxy(
            locationStorage: locationStorage,
            cLLocationManager: cLLocationManager
        )

        let locationManagerDelegate = LocationManagerDelegate(locationDelegateProxy: locationDelegateProxy)

        let locationManager = LocationManager(
            cLLocationManager: cLLocationManager,
            geoLogger: geoLogger,
            locationManagerDelegate: locationManagerDelegate,
            locationDelegateProxy: locationDelegateProxy
        )

        return .init(
            geoLogger: geoLogger,
            locationManager: locationManager
        )
    }
}
