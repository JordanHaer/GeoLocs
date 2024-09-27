import Testing
@testable import GeoLocs

import CoreLocation

@Suite
struct LocationAuthStatusTests {

    @Test
    func example1() {
        let foo = LocationAuthStatus(.notDetermined)
        let bar = LocationAuthStatus.notDetermined

        #expect(foo == bar)
    }

    @Test
    func example2() {
        let foo = LocationAuthStatus(.denied)
        let bar = LocationAuthStatus.denied

        #expect(foo == bar)
    }

    @Test
    func example3() {
        let foo = LocationAuthStatus(.restricted)
        let bar = LocationAuthStatus.denied

        #expect(foo == bar)
    }

    @Test
    func example4() {
        let foo = LocationAuthStatus(.authorizedAlways)
        let bar = LocationAuthStatus.authorizedAlways

        #expect(foo == bar)
    }

    @Test
    func example5() {
        let foo = LocationAuthStatus(.authorizedWhenInUse)
        let bar = LocationAuthStatus.authorizedWhenInUse

        #expect(foo == bar)
    }

    @Test
    func example6() throws {
        let optionalUnknownCLAuthorizationStatus = CLAuthorizationStatus(rawValue: 100)
        let unknownCLAuthorizationStatus = try #require(optionalUnknownCLAuthorizationStatus)

        let foo = LocationAuthStatus(unknownCLAuthorizationStatus)
        let bar = LocationAuthStatus.unknown

        #expect(foo == bar)
    }
}
