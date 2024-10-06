import CoreLocation

protocol LocationManagerFactoryProtocol: Sendable {
    func build(locationEventCallback: @escaping LocationEventCallback) -> LocationManagerProtocol
}

struct LocationManagerFactory: LocationManagerFactoryProtocol {
    func build(locationEventCallback: @escaping LocationEventCallback) -> LocationManagerProtocol {
        let locationStorage = LocationStorage()
        let cLLocationManager = CLLocationManager()

        let locationDelegateProxy = LocationDelegateProxy(
            locationStorage: locationStorage,
            cLLocationManager: cLLocationManager,
            locationEventCallback: locationEventCallback
        )

        let locationManagerDelegate = LocationManagerDelegate(locationDelegateProxy: locationDelegateProxy)

        return LocationManager(
            cLLocationManager: cLLocationManager,
            locationManagerDelegate: locationManagerDelegate,
            locationDelegateProxy: locationDelegateProxy
        )
    }
}
