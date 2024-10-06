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

    func setup(locationEventCallback: @escaping LocationEventCallback) async throws(MGeoError)

    func requestLocationAuthStatus() async throws(MGeoError) -> LocationAuthStatus

    func startUpdatingLocation() async throws(MGeoError)

    func stopUpdatingLocation() async throws(MGeoError)
}
