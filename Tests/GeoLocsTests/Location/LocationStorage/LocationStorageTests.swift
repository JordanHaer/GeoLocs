import Testing
@testable import GeoLocs

@Suite
struct LocationStorageTests {

    @Suite
    struct AddTests {

        private let sut: LocationStorageProtocol

        init() {
            self.sut = LocationStorage()
        }

        @Test
        func givenNoLocationEvents_whenAddingALocationEvent_ThenNumberOfLocationEventsEqualsOne() async {
            await sut.add(.invalid(.outOfRegion))

            let expectedNumberOfLocationEvents = 1
            let actualNumberOfLocationEvents = await sut.getAllLocationEvents().count

            #expect(expectedNumberOfLocationEvents == actualNumberOfLocationEvents)
        }

        @Test
        func givenNoLocationEvents_whenAddingAElevenLocationEvents_ThenNumberOfLocationEventsEqualsTen() async {
            for _ in 0..<11 {
                await sut.add(.invalid(.outOfRegion))
            }

            let expectedNumberOfLocationEvents = 10
            let actualNumberOfLocationEvents = await sut.getAllLocationEvents().count

            #expect(expectedNumberOfLocationEvents == actualNumberOfLocationEvents)
        }

        @Test
        func givenNoLocationEvents_whenAddingAElevenLocationEvents_ThenLocationEventsContainsTenMostRecentLocationEvents() async {
            for _ in 0..<6 {
                await sut.add(.invalid(.outOfRegion))
            }

            for _ in 0..<6 {
                await sut.add(.invalid(.locationUnavailable))
            }

            let expectedLocationEvents: [LocationEvent] = [
                .invalid(.outOfRegion),
                .invalid(.outOfRegion),
                .invalid(.outOfRegion),
                .invalid(.outOfRegion),
                .invalid(.locationUnavailable),
                .invalid(.locationUnavailable),
                .invalid(.locationUnavailable),
                .invalid(.locationUnavailable),
                .invalid(.locationUnavailable),
                .invalid(.locationUnavailable)
            ]
            let actualLocationEvents = await sut.getAllLocationEvents()

            #expect(expectedLocationEvents == actualLocationEvents)
        }
    }

    @Suite
    struct GetAllLocationEventsTests {

        private let sut: LocationStorageProtocol

        init() {
            self.sut = LocationStorage()
        }

        @Test
        func givenNoLocationEvents_whenGettingAllLocationEvents_thenNoLocationEventsAreReturned() async {
            let expectedLocationEvents: [LocationEvent] = []
            let actualLocationEvents = await sut.getAllLocationEvents()

            #expect(expectedLocationEvents == actualLocationEvents)
        }

        @Test
        func givenLocationEventsHaveOccured_whenGettingAllLocationEvents_thenLocationEventsAreReturned() async {
            await sut.add(.invalid(.locationUnavailable))
            await sut.add(.permission(.authorizedWhenInUse))

            let expectedLocationEvents: [LocationEvent] = [
                .invalid(.locationUnavailable),
                .permission(.authorizedWhenInUse)
            ]
            let actualLocationEvents = await sut.getAllLocationEvents()

            #expect(expectedLocationEvents == actualLocationEvents)
        }
    }

    @Suite
    struct GetLatestLocationEventTests {

        private let sut: LocationStorageProtocol

        init() {
            self.sut = LocationStorage()
        }

        @Test
        func givenNoLocationEvents_whenGettingLatestLocationEvent_thenNilIsReturned() async {
            let actualLatestLocationEvent = await sut.getLatestLocationEvent()
            #expect(actualLatestLocationEvent == nil)
        }

        @Test
        func givenTwoDifferentLocationEvents_whenGettingLatestLocationEvent_thenLatestLocationEventIsReturned() async {
            await sut.add(.invalid(.locationUnavailable))
            await sut.add(.invalid(.outOfRegion))

            let expectedLatestLocationEvent: LocationEvent = .invalid(.outOfRegion)
            let actualLatestLocationEvent = await sut.getLatestLocationEvent()

            #expect(expectedLatestLocationEvent == actualLatestLocationEvent)
        }
    }

    @Suite
    struct GetAllValidLocationEventsTests {

        private let sut: LocationStorageProtocol

        init() {
            self.sut = LocationStorage()
        }

        @Test
        func givenNoLocationEvents_whenGettingValidLocationEvents_thenNoLocationEventsAreReturned() async {
            let expectedValidLocationEvents: [LocationEvent] = []
            let actualValidLocationEvents = await sut.getAllValidLocationEvents()

            #expect(expectedValidLocationEvents == actualValidLocationEvents)
        }

        @Test
        func givenMultipleInvalidLocationEvents_whenGettingValidLocationEvents_thenNoLocationEventsAreReturned() async {
            await sut.add(.invalid(.locationUnavailable))
            await sut.add(.invalid(.outOfRegion))

            let expectedValidLocationEvents: [LocationEvent] = []
            let actualValidLocationEvents = await sut.getAllValidLocationEvents()

            #expect(expectedValidLocationEvents == actualValidLocationEvents)
        }

        @Test
        func givenAnInvalidLocationEventAndAValidLocationEvent_whenGettingValidLocationEvents_thenOneValidLocationEventIsReturned() async {
            await sut.add(.invalid(.locationUnavailable))
            await sut.add(.valid(.init(latitude: 0, longitude: 0, locationType: .mono)))

            let expectedValidLocationEvents: [LocationEvent] = [
                .valid(.init(latitude: 0, longitude: 0, locationType: .mono))
            ]
            let actualValidLocationEvents = await sut.getAllValidLocationEvents()

            #expect(expectedValidLocationEvents == actualValidLocationEvents)
        }

        @Test
        func givenMultipleInvalidLocationEventsAndMultipleValidLocationEvents_whenGettingValidLocationEvents_thenOnlyValidLocationEventsAreReturned() async {
            await sut.add(.invalid(.locationUnavailable))
            await sut.add(.valid(.init(latitude: 0, longitude: 0, locationType: .mono)))
            await sut.add(.invalid(.outOfRegion))
            await sut.add(.valid(.init(latitude: 1, longitude: 1, locationType: .async)))

            let expectedValidLocationEvents: [LocationEvent] = [
                .valid(.init(latitude: 0, longitude: 0, locationType: .mono)),
                .valid(.init(latitude: 1, longitude: 1, locationType: .async))
            ]
            let actualValidLocationEvents = await sut.getAllValidLocationEvents()

            #expect(expectedValidLocationEvents == actualValidLocationEvents)
        }
    }

    @Suite
    struct GetAllInValidLocationEventsTests {

        private let sut: LocationStorageProtocol

        init() {
            self.sut = LocationStorage()
        }

        @Test
        func givenNoLocationEvents_whenGettingInvalidLocationEvents_thenNoLocationEventsAreReturned() async {
            let expectedInvalidLocationEvents: [LocationEvent] = []
            let actualInvalidLocationEvents = await sut.getAllInvalidLocationEvents()

            #expect(expectedInvalidLocationEvents == actualInvalidLocationEvents)
        }

        @Test
        func givenMultipleValidLocationEvents_whenGettingInvalidLocationEvents_thenNoLocationEventsAreReturned() async {
            await sut.add(.valid(.init(latitude: 0, longitude: 0, locationType: .mono)))
            await sut.add(.valid(.init(latitude: 1, longitude: 1, locationType: .async)))

            let expectedInvalidLocationEvents: [LocationEvent] = []
            let actualInvalidLocationEvents = await sut.getAllInvalidLocationEvents()

            #expect(expectedInvalidLocationEvents == actualInvalidLocationEvents)
        }

        @Test
        func givenAnInvalidLocationEventAndAValidLocationEvent_whenGettingInvalidLocationEvents_thenOneInvalidLocationEventIsReturned() async {
            await sut.add(.invalid(.locationUnavailable))
            await sut.add(.valid(.init(latitude: 0, longitude: 0, locationType: .mono)))

            let expectedInvalidLocationEvents: [LocationEvent] = [
                .invalid(.locationUnavailable)
            ]
            let actualInvalidLocationEvents = await sut.getAllInvalidLocationEvents()

            #expect(expectedInvalidLocationEvents == actualInvalidLocationEvents)
        }

        @Test
        func givenMultipleInvalidLocationEventsAndMultipleValidLocationEvents_whenGettingInvalidLocationEvents_thenOnlyInvalidLocationEventsAreReturned() async {
            await sut.add(.invalid(.locationUnavailable))
            await sut.add(.valid(.init(latitude: 0, longitude: 0, locationType: .mono)))
            await sut.add(.invalid(.outOfRegion))
            await sut.add(.valid(.init(latitude: 1, longitude: 1, locationType: .async)))

            let expectedInvalidLocationEvents: [LocationEvent] = [
                .invalid(.locationUnavailable),
                .invalid(.outOfRegion)
            ]
            let actualInvalidLocationEvents = await sut.getAllInvalidLocationEvents()

            #expect(expectedInvalidLocationEvents == actualInvalidLocationEvents)
        }
    }
}
