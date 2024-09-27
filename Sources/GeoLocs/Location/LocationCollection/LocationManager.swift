import CoreLocation

protocol LocationManagerProtocol: Actor {
    func setLocationEventCallback(_ locationEventCallback: @escaping LocationEventCallback) async

    func requestWhenInUseLocationPermission()
    func requestLocationAuthStatus() -> LocationAuthStatus

    func startUpdatingLocation()
    func stopUpdatingLocation()
}

final actor LocationManager: LocationManagerProtocol {

    private var locationAuthStatus: LocationAuthStatus {
        .init(cLLocationManager.locationAuthStatus)
    }

    private var cLLocationManager: CLLocationManagerProtocol

    private let geoLogger: GeoLoggerProtocol
    private let locationManagerDelegate: LocationManagerDelegateProtocol
    private var locationDelegateProxy: LocationDelegateProxyProtocol

    init(
        cLLocationManager: CLLocationManagerProtocol,
        geoLogger: GeoLoggerProtocol,
        locationManagerDelegate: LocationManagerDelegateProtocol,
        locationDelegateProxy: LocationDelegateProxyProtocol
    ) {
        self.cLLocationManager = cLLocationManager
        self.geoLogger = geoLogger
        self.locationManagerDelegate = locationManagerDelegate
        self.locationDelegateProxy = locationDelegateProxy

        self.cLLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.cLLocationManager.distanceFilter = kCLDistanceFilterNone
        self.cLLocationManager.delegate = locationManagerDelegate
    }

    func setLocationEventCallback(_ locationEventCallback: @escaping LocationEventCallback) async {
        await locationDelegateProxy.setLocationEventCallback(locationEventCallback)
        requestWhenInUseLocationPermission()
    }

    func requestWhenInUseLocationPermission() {
        cLLocationManager.requestWhenInUseAuthorization()
    }

    func requestLocationAuthStatus() -> LocationAuthStatus {
        locationAuthStatus
    }

    func startUpdatingLocation() {
        cLLocationManager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        cLLocationManager.stopUpdatingLocation()
    }
}
