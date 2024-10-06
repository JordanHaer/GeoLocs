import CoreLocation

import Foundation
import SwiftUI

protocol CLLocationManagerProtocol: LocationAuthStatusProtocol {
    var desiredAccuracy: CLLocationAccuracy { get set }
    var distanceFilter: CLLocationDistance { get set }
    var delegate: CLLocationManagerDelegate? { get set }

    func requestWhenInUseAuthorization()
    func startUpdatingLocation()
    func stopUpdatingLocation()
}
