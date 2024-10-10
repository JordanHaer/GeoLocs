import Testing
@testable import GeoLocs

import CoreLocation

@Suite
struct LocationManagerDelegateTests {

    enum MockCLError: Error, Equatable {
        case mockError
    }

    private let mockCLLocation: CLLocation = .init(latitude: 0, longitude: 0)
    private let mockCLLocationManager: CLLocationManager
    private let locationDelegateMethodStream: LocationDelegateMethodStream
    private let sut: LocationManagerDelegate

    init() {
        let (locationDelegateMethodStream, continuation) = AsyncStream.makeStream(of: LocationDelegateMethod.self)

        self.mockCLLocationManager = .init()
        self.locationDelegateMethodStream = locationDelegateMethodStream
        self.sut = LocationManagerDelegate(
            locationDelegateMethodStream: locationDelegateMethodStream,
            continuation: continuation
        )
    }

    @Test
    func locationPassedToDelegateProxy() async {
        sut.locationManager(mockCLLocationManager, didUpdateLocations: [mockCLLocation])

        for await locationDelegateMethod in locationDelegateMethodStream {
            switch locationDelegateMethod {
            case let .didUpdateLocations(locations: locations):
                #expect(locations == [mockCLLocation])
            default:
                Issue.record()
            }
            break
        }
    }

    @Test
    func errorPassedToDelegateProxy() async throws {
        sut.locationManager(mockCLLocationManager, didFailWithError: MockCLError.mockError)

        for await locationDelegateMethod in locationDelegateMethodStream {
            switch locationDelegateMethod {
            case let .didFailWithError(error: error):
                let mockCLError = try #require(error as? MockCLError)
                #expect(mockCLError == MockCLError.mockError)
            default:
                Issue.record()
            }
            break
        }
    }

    @Test
    func didChangeAuthorization() async {
        sut.locationManagerDidChangeAuthorization(mockCLLocationManager)

        for await locationDelegateMethod in locationDelegateMethodStream {
            switch locationDelegateMethod {
            case .didChangeAuthorization:
                break
            default:
                Issue.record()
            }
            break
        }
    }
}
