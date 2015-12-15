
import Foundation

public struct Position : Hashable, CustomStringConvertible {
    public var x:Int
    public var y:Int
    
    public init(_ x: Int, _ y: Int) {
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

public struct RectangleGenerator: GeneratorType {
    let rect: Rectangle

    private var nextX = 0
    private var nextY = 0
    
    public init(rectangle: Rectangle) { self.rect = rectangle }
    
    mutating public func next() -> Position? {
        let pos = Position(rect.topLeft.x + nextX, rect.topLeft.y + nextY)
        if ++nextX >= rect.width {
            nextX = 0
            nextY++
        }
        if pos.y >= rect.height + rect.topLeft.y {
            return nil
        }
        return pos
    }
}

public struct Rectangle : CustomStringConvertible, SequenceType {
    let topLeft:Position
    let bottomRight:Position
    
    public init(topLeft tl: Position, bottomRight br: Position) {
        topLeft = tl
        bottomRight = br
    }
    
    public init(_ string: String) {
        let range = string.rangeOfString(" through ")!
        let tl = string.substringToIndex(range.startIndex).characters.split(",").map { Int(String($0))! }
        let br = string.substringFromIndex(range.endIndex).characters.split(",").map { Int(String($0))! }
        topLeft = Position(tl[0],tl[1])
        bottomRight = Position(br[0], br[1])
    }
    
    public var width:Int {
        return bottomRight.x - topLeft.x + 1
    }
    
    public var height:Int {
        return bottomRight.y - topLeft.y + 1
    }
    
    public func generate() -> RectangleGenerator {
        return RectangleGenerator(rectangle: self)
    }
    
    public var description:String {
        return "(\(topLeft))(\(bottomRight))"
    }
}

public struct Command : CustomStringConvertible {
    public enum Type: String {
        case TurnOn = "turn on", TurnOff = "turn off", Toggle = "toggle"
        static let allValues = [TurnOn, TurnOff, Toggle]
    }
    
    public enum Error: ErrorType { case InvalidCommand }
    
    public let area:Rectangle
    public let type:Type
    
    public init (type t:Type, area a: Rectangle) {
        type = t
        area = a
    }
    
    public init (_ string:String) throws {
        for commandType in Type.allValues {
            if string.characters.startsWith(commandType.rawValue.characters) {
                let rectIndex = string.rangeOfString(commandType.rawValue)!.endIndex.advancedBy(1)
                area = Rectangle(string.substringFromIndex(rectIndex))
                type = commandType
                return
            }
        }
        throw Error.InvalidCommand
    }
    
    
    public var description:String {
        return "Command: \(type.rawValue) \(area)"
    }
    
}

public struct Light : CustomStringConvertible {
    public let position:Position
    private var state:Bool = false
    private var _brightness:Int = 0
    
    init(position pos: Position) {
        position = pos
    }
    
    public mutating func toggle() {
        state = !state
        _brightness += 2
    }
    
    public mutating func turnOn() {
        state = true
        _brightness += 1
    }
    
    public mutating func turnOff() {
        state = false
        _brightness -= 1
        if _brightness < 0 { _brightness = 0 }
    }
    
    public var description:String {
        if state {
            return "On"
        } else {
            return "Off"
        }
    }
    
    var isOn:Bool { return state }
    var brightness:Int { return _brightness }
}

public struct LightGrid  {
    let width:Int
    let height:Int
    
    private var lookup:[Position:Light] = [:]
    
    enum Error: ErrorType { case OutOfBounds }
    
    public init(width w:Int, height h:Int) {
        for x in 0..<w {
            for y in 0..<h {
                let light = Light(position: Position(x, y))
                lookup[light.position] = light
            }
        }
        width = w
        height = h
    }
    
    public var lights:[Light] {
        return [Light](lookup.values)
    }
    
    public var onCount:Int {
        return lights.filter { $0.isOn }.count
    }
    
    public var totalBrightness:Int {
        return lights.reduce(0, combine: { $0 + $1.brightness })
    }
    
    mutating public func runCommand(command:Command) throws {
        for pos in command.area {
            if lookup[pos] != nil {
                switch command.type {
                case .Toggle:
                    lookup[pos]!.toggle()
                case .TurnOff:
                    lookup[pos]!.turnOff()
                case .TurnOn:
                    lookup[pos]!.turnOn()
                }
            } else {
                throw Error.OutOfBounds
            }
        }
    }
}
