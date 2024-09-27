@frozen
public enum LocationEvent: Sendable, Equatable {
    case valid(Location)
    case invalid(LocationError)
    case permission(LocationAuthStatus)
}
