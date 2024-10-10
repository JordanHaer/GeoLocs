import CoreLocation

@MainActor
protocol LocationManagerFactoryProtocol: Sendable {
    func build(locationEventCallback: @escaping LocationEventCallback) -> LocationManagerProtocol
}

struct LocationManagerFactory: LocationManagerFactoryProtocol {
    func build(locationEventCallback: @escaping LocationEventCallback) -> LocationManagerProtocol {
        let (locationDelegateMethodStream, continuation) = AsyncStream.makeStream(of: LocationDelegateMethod.self)
        let locationManagerDelegate = LocationManagerDelegate(
            locationDelegateMethodStream: locationDelegateMethodStream,
            continuation: continuation
        )

        let locationStorage = LocationStorage()

        let cLLocationManager = CLLocationManager()

        let locationDelegateProxy = LocationDelegateProxy(
            locationStorage: locationStorage,
            cLLocationManager: cLLocationManager,
            locationManagerDelegate: locationManagerDelegate,
            locationEventCallback: locationEventCallback
        )

        return LocationManager(
            cLLocationManager: cLLocationManager,
            locationManagerDelegate: locationManagerDelegate,
            locationDelegateProxy: locationDelegateProxy
        )
    }
}
