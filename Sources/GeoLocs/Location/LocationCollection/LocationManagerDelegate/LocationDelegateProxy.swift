import CoreLocation

protocol LocationDelegateProxyProtocol: Actor {
    func listenForLocationManagerDelegate() async
}

final actor LocationDelegateProxy: LocationDelegateProxyProtocol {

    private let locationStorage: LocationStorageAddProtocol
    private let cLLocationManager: LocationAuthStatusProtocol
    private let locationManagerDelegate: LocationManagerDelegateProtocol
    private let locationEventCallback: LocationEventCallback

    init(
        locationStorage: LocationStorageAddProtocol,
        cLLocationManager: LocationAuthStatusProtocol,
        locationManagerDelegate: LocationManagerDelegateProtocol,
        locationEventCallback: @escaping LocationEventCallback
    ) {
        self.locationStorage = locationStorage
        self.cLLocationManager = cLLocationManager
        self.locationManagerDelegate = locationManagerDelegate
        self.locationEventCallback = locationEventCallback
    }

    func listenForLocationManagerDelegate() async {
        for await locationDelegateMethod in locationManagerDelegate.locationDelegateMethodStream {
            await perform(locationDelegateMethod)
        }
    }

    private func perform(_ locationDelegateMethod: LocationDelegateMethod) async {
        switch locationDelegateMethod {
        case .didUpdateLocations(let locations):
            await didUpdateLocations(locations: locations)
        case .didFailWithError(let error):
            await didFailWithError(error: error)
        case .didChangeAuthorization:
            didChangeAuthorization()
        }
    }

    private func didUpdateLocations(locations: [CLLocation]) async {
        guard let location = locations.last else {
            return await sendInvalidLocationEvent()
        }

        await sendValidLocationEvent(location)
    }

    private func didFailWithError(error: Error) async {
        await sendInvalidLocationEvent()
    }

    private func didChangeAuthorization() {
        let authStatus = LocationAuthStatus(cLLocationManager.locationAuthStatus)
        let authStatusEvent = LocationEvent.permission(authStatus)
        locationEventCallback(authStatusEvent)
    }

    private func sendValidLocationEvent(_ location: CLLocation) async {
        let newLocation = Location(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            locationType: .async
        )

        let locationEvent = LocationEvent.valid(newLocation)

        await sendLocationEvent(locationEvent)
    }

    private func sendInvalidLocationEvent() async {
        let locationEvent = LocationEvent.invalid(.locationUnavailable)
        await sendLocationEvent(locationEvent)
    }

    private func sendLocationEvent(_ locationEvent: LocationEvent) async {
        await locationStorage.add(locationEvent)
        locationEventCallback(locationEvent)
    }
}
