import CoreLocation

protocol LocationManagerProtocol: Actor {
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

    private let locationManagerDelegate: LocationManagerDelegateProtocol
    private let locationDelegateProxy: LocationDelegateProxyProtocol

    init(
        cLLocationManager: CLLocationManagerProtocol,
        locationManagerDelegate: LocationManagerDelegateProtocol,
        locationDelegateProxy: LocationDelegateProxyProtocol
    ) {
        self.cLLocationManager = cLLocationManager
        self.locationManagerDelegate = locationManagerDelegate
        self.locationDelegateProxy = locationDelegateProxy

        self.cLLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.cLLocationManager.distanceFilter = kCLDistanceFilterNone
        self.cLLocationManager.delegate = locationManagerDelegate
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
