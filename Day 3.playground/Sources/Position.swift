import Foundation

public struct Position : Hashable, CustomStringConvertible {
    public var x:Int
    public var y:Int
    
    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    public var description:String {
        return "\(x),\(y)"
    }
    
    public var hashValue:Int {
        return description.hashValue
    }
}

public func ==(lhs: Position, rhs: Position) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}
