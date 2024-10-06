@testable import GeoLocs

struct MockLocationManagerFactory: LocationManagerFactoryProtocol {

    private let locationManager: LocationManagerProtocol

    init(locationManager: LocationManagerProtocol) {
        self.locationManager = locationManager
    }

    func build(locationEventCallback: @escaping LocationEventCallback) -> LocationManagerProtocol {
        locationManager
    }
}
