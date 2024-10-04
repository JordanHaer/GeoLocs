/// A protocol for the ``MGeo`` class.
public protocol MGeoProtocol: Sendable {

    /// The current version of the `GeoLocs` SDK.
    ///
    /// This constant holds the version number of the `GeoLocs` SDK as a string.
    /// It is used to identify the release version of the SDK.
    ///
    /// ```swift
    /// print(MGeo.version)
    /// // Output: "0.0.1"
    /// ```
    static var version: String { get }

    /// Initialises an instance of the `MGeo` class
    ///
    /// This initialiser takes no parameters
    ///
    /// - Important: Ensure that only one instance of the `MGeo`
    /// class is created in order for the SDK to work as intended.
    ///
    /// Example usage:
    /// ```swift
    /// // initialising the MGeo class
    /// let mGeo = MGeo()
    ///
    /// // calling methods on the MGeo class
    /// mGeo.setup(
    ///     locationEventCallback: locationEventCallback,
    ///     setupFinishedHandler: setupFinishedHandler
    /// )
    /// ```
    init(logLevel: LogLevel)

    func setup(locationEventCallback: @escaping LocationEventCallback) async -> Bool

    func requestLocationAuthStatus() async -> LocationAuthStatus

    func startUpdatingLocation() async

    func stopUpdatingLocation() async

    func setup(
        locationEventCallback: @escaping LocationEventCallback,
        setupFinishedHandler completion: @escaping SetupFinishedCompletion
    )

    /// Requests the current location authorization status.
    ///
    /// This method checks the user's location authorization status and passes the result
    /// to the provided completion handler. The status indicates whether the app has permission
    /// to access location services (e.g., `authorized`, `denied`, `restricted`, etc.).
    ///
    /// - Parameter completion: A closure that is called with the current authorization status.
    ///   The closure takes a single argument of type `LocationAuthStatus`, which represents the user's
    ///   location authorization state.
    ///
    /// Example usage:
    /// ```swift
    /// mGeo.requestLocationAuthStatus { status in
    ///     switch status {
    ///     case .authorized:
    ///         print("Location access granted")
    ///     case .denied:
    ///         print("Location access denied")
    ///     default:
    ///         print("Location access restricted or unknown")
    ///     }
    /// }
    /// ```
    func requestLocationAuthStatus(_ completion: @escaping LocationAuthStatusCompletion)

    /// Starts location updates.
    ///
    /// This method begins monitoring the user's location and triggers location update events
    /// via the `locationEventCallback` provided in the `setup` method.
    /// Ensure that location services are properly authorized before calling this method.
    ///
    /// - Important: Call `setup` before starting location updates.
    ///
    /// Example usage:
    /// ```swift
    /// mGeo.startUpdatingLocation()
    /// ```
    func startUpdatingLocation()

    /// Stops location updates.
    ///
    /// This method stops monitoring the user's location, halting location update events.
    /// It should be called when location tracking is no longer needed to conserve battery and resources.
    ///
    /// Example usage:
    /// ```swift
    /// mGeo.stopUpdatingLocation()
    /// ```
    func stopUpdatingLocation()
}
