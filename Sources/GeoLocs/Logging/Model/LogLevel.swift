import Foundation

/// Defines the log level used within the SDK.
///
/// This enum is used to control whether logging is enabled in the SDK.
/// The `LogLevel` is set in the initialiser of the ``MGeo`` class.
///
/// Example implementation.
///
/// ```swift
/// // SDK logging enabled
/// let mGeo = MGeo(logLevel: .debug)
///
/// // SDK logging disbled
/// let mGeo = MGeo(logLevel: .release)
/// // or
/// let mGeo = MGeo()
/// ```
public enum LogLevel: Sendable, CaseIterable {

    /// Logs from the SDK are enabled
    ///
    /// Use this `LogLevel` during development and testing to see logs debug information, warnings, and errors..
    case debug

    /// Logs from the SDK are disabled.
    ///
    /// Use this `LogLevel` in release builds.
    case release
}
