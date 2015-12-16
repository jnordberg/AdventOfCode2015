import Foundation

public typealias Distance = Int
public typealias Score = UInt16

public class Location : Hashable, CustomStringConvertible {
    
    let name:String
    var connections:[Location:Distance] = [:]
    
    public enum Error: ErrorType {
        case NoRoute
    }
    
    public init(_ name: String) {
        self.name = name
    }
    
    public func addConnection(location: Location, distance: Distance) {
        assert(connections[location] == nil, "Already have connection to location")
        connections[location] = distance
    }
    
    public func distanceTo(location: Location) throws -> Distance {
        if connections[location] == nil {
            throw Error.NoRoute
        }
        return connections[location]!
    }
    
    public var description:String {
        return name
    }
    
    public var hashValue:Int {
        return description.hashValue
    }
}

public func ==(lhs: Location, rhs: Location) -> Bool {
    return lhs.name == rhs.name
}

public extension CollectionType where Generator.Element: Location {
    
    func getTraveledDistance() throws -> Distance {
        let initial:(Distance, Location?) = (0, nil)
        let result = try reduce(initial) {
            var traveled = $0.0
            if let location = $0.1 as Location? {
                traveled += try location.distanceTo($1)
            }
            return (traveled, $1)
        }
        return result.0
    }
    
}