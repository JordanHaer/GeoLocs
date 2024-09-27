import Foundation

struct GeoLogger: GeoLoggerProtocol {

    private let logLevel: LogLevel
    private let dateFormatter: DateFormatter

    init(logLevel: LogLevel) {
        self.logLevel = logLevel
        self.dateFormatter = Self.createDateFormatter()
    }

    func geoLog(
        logType: LogType,
        message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        guard logLevel == .debug else {
            return
        }

        let fileName = URL(fileURLWithPath: file).lastPathComponent
        let timestamp = dateFormatter.string(from: Date())

        let log = "\(timestamp) [\(logType.rawValue)] [\(fileName)]:\(line) \(function) -> \(message)"

        print(log)
    }

    func getLogLevel() -> LogLevel {
        self.logLevel
    }

    private static func createDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return formatter
    }
}
