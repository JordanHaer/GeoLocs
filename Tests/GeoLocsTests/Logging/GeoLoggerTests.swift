import Testing
@testable import GeoLocs

@Suite
struct GeoLoggerTests {

    @Test(arguments: LogLevel.allCases)
    func logLevelInGeoLoggerInitEqualsLogLevelPropertyValue(logLevel: LogLevel) async {
        let sut = GeoLogger(logLevel: logLevel)

        let expectedLogLevel = logLevel
        let actualLogLevel = sut.getLogLevel()

        #expect(expectedLogLevel == actualLogLevel)
    }
}
