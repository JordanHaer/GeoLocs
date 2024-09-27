/// A type alias for a closure that handles `LocationEvent` objects.
///
/// This closure is marked as `@Sendable`, meaning it can be safely used in
/// concurrent contexts. It takes a `LocationEvent` as a parameter and performs
/// any necessary processing on the event.
///
/// - Parameters:
///   - locationEvent: The `LocationEvent` that contains data about the current
///   or recent location changes.
///
/// Usage example:
/// ```swift
/// let callback: LocationEventCallback = { event in
///     print("Location changed: \(event)")
/// }
/// ```
///
/// - Note: Ensure this closure handles location events in a thread-safe manner
/// if used across threads.
public typealias LocationEventCallback = @Sendable (_ locationEvent: LocationEvent) -> Void
