@frozen
public enum LocationError: Error {
    case outOfRegion
    case locationUnavailable
    case taskCancel
}
