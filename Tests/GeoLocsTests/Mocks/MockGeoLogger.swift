@testable import GeoLocs

struct MockGeoLogger: GeoLoggerProtocol {

    private let logLevel: LogLevel

    init(logLevel: LogLevel) {
        self.logLevel = logLevel
    }

    func geoLog(
        logType: LogType,
        message: String
    ) {}

    func getLogLevel() -> LogLevel {
        logLevel
    }
}
