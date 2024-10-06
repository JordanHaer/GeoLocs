@testable import GeoLocs

import CoreLocation

final class MockLocationManagerDelegate: NSObject, LocationManagerDelegateProtocol {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {}
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {}
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {}
}
