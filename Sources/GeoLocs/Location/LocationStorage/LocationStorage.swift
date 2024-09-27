protocol LocationStorageProtocol: LocationStorageAddProtocol {
    func getAllLocationEvents() -> [LocationEvent]
    func getLatestLocationEvent() -> LocationEvent?
    func getAllValidLocationEvents() -> [LocationEvent]
    func getAllInvalidLocationEvents() -> [LocationEvent]
}

protocol LocationStorageAddProtocol: Actor {
    func add(_ locationEvent: LocationEvent)
}

final actor LocationStorage: LocationStorageProtocol {

    private var locations: [LocationEvent] = []

    init() {}

    func add(_ locationEvent: LocationEvent) {
        if locations.count == 10 {
            locations.removeFirst()
        }
        locations.append(locationEvent)
    }

    func getAllLocationEvents() -> [LocationEvent] {
        locations
    }

    func getLatestLocationEvent() -> LocationEvent? {
        locations.last
    }

    func getAllValidLocationEvents() -> [LocationEvent] {
        locations.filter { locationEvent in
            if case .valid = locationEvent {
                return true
            } else {
                return false
            }
        }
    }

    func getAllInvalidLocationEvents() -> [LocationEvent] {
        locations.filter { locationEvent in
            if case .invalid = locationEvent {
                return true
            } else {
                return false
            }
        }
    }
}
