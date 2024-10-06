/// A struct representing a geographical location with latitude, longitude, and a type.
///
/// The `Location` struct is `Sendable` and `Equatable`, making it safe for use in concurrent contexts
/// and allowing comparison between instances.
///
/// - Important: Ensure that latitude and longitude values are valid and within appropriate ranges
///   (latitude: -90 to 90, longitude: -180 to 180).
public struct Location: Sendable, Equatable {

    /// An enumeration representing the type of location.
    ///
    /// The `LocationType` enum defines the category of the location, such as whether it is a mono
    /// or async location.
    @frozen
    public enum LocationType: Sendable {

        /// Represents a mono location type.
        case mono

        /// Represents a async location type.
        case async
    }

    /// The latitude coordinate of the location.
    ///
    /// Latitude is a double value that indicates the north-south position on the Earth's surface.
    /// The value should be within the range of -90 to 90 degrees.
    public let latitude: Double

    /// The longitude coordinate of the location.
    ///
    /// Longitude is a double value that indicates the east-west position on the Earth's surface.
    /// The value should be within the range of -180 to 180 degrees.
    public let longitude: Double

    /// The type of location.
    ///
    /// This property uses the `LocationType` enum to specify the category or nature of the location,
    /// such as whether it is mono or async.
    public let locationType: LocationType
}

public extension Location {
    /// This `Location` object is to be used for SwiftUI previews and mocking.
    ///
    /// Example usage:
    /// ```swift
    /// import SwiftUI
    /// import GeoLocs
    ///
    /// struct ContentView: View {
    ///
    ///     private let location: GeoLocs.Location
    ///
    ///     init(location: GeoLocs.Location) {
    ///         self.location = location
    ///     }
    ///
    ///     var body: some View {
    ///         VStack {
    ///             Text("Latitude \(location.latitude)")
    ///             Text("Longitude \(location.longitude)")
    ///             Text("Location Type: /\(location.locationType)")
    ///         }
    ///     }
    /// }
    ///
    /// #Preview {
    ///     ContentView(location: .dummyLocation)
    /// }
    /// ```
    static let dummyLocation = Self(
        latitude: 1.234567,
        longitude: 7.654321,
        locationType: .mono
    )
}
