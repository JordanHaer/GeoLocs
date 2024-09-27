@testable import GeoLocs

struct MockGeoLogger: GeoLoggerProtocol {
    func geoLog(
        logType: LogType,
        message: String
    ) {}
}
