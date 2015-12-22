import Foundation
import Cocoa

public struct Position : Hashable, CustomStringConvertible {
    let x:Int
    let y:Int
    
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

public func == (left: Position, right: Position) -> Bool {
    return left.x == right.x && left.y == right.y
}

public func + (left: Position, right: Position) -> Position {
    return Position(left.x + right.x, left.y + right.y)
}

public func - (left: Position, right: Position) -> Position {
    return Position(left.x - right.x, left.y - right.y)
}

public func * (left: Position, right: Position) -> Position {
    return Position(left.x * right.x, left.y * right.y)
}

public func * (left: Position, right: Int) -> Position {
    return left * Position(right, right)
}


public struct RectangleGenerator: GeneratorType {
    let rect: Rectangle
    
    private var nextX = 0
    private var nextY = 0
    
    public init(rectangle: Rectangle) { self.rect = rectangle }
    
    mutating public func next() -> Position? {
        let pos = Position(rect.topLeft.x + nextX, rect.topLeft.y + nextY)
        if ++nextX > rect.width {
            nextX = 0
            nextY++
        }
        if pos.y > rect.height + rect.topLeft.y {
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
    
    public var width:Int {
        return bottomRight.x - topLeft.x
    }
    
    public var height:Int {
        return bottomRight.y - topLeft.y
    }
    
    public func generate() -> RectangleGenerator {
        return RectangleGenerator(rectangle: self)
    }
    
    public var description:String {
        return "(\(topLeft))(\(bottomRight))"
    }
    
    public func scale(factor: Int) -> Rectangle {
        return Rectangle(topLeft: topLeft, bottomRight: bottomRight * factor)
    }
    
    public var corners:[Position] {
        let topRight = topLeft + Position(width, 0)
        let bottomLeft = topLeft + Position(0, height)
        return [topLeft, topRight, bottomLeft, bottomRight]
    }
    
}

public extension NSPoint {
    
    public init(_ position: Position) {
        self.x = CGFloat(position.x)
        self.y = CGFloat(position.y)
    }
}

public extension NSRect {
    
    public init(_ rect: Rectangle) {
        self.origin = NSPoint(rect.topLeft)
        self.size = NSSize(width: rect.width, height: rect.height)
    }
    
}

public protocol LightType {
    var isOn:Bool { get }
    var isOff:Bool { get }
}

public struct Light : LightType {
    
    public enum State {
        case On, Off, Stuck
    }
    
    public var state:State = .Off
    
    public init(state: State) {
        self.state = state
    }
    
    public var isOn:Bool {
        return (state == .On || state == .Stuck)
    }
    
    public var isOff:Bool {
        return state == .Off
    }
    
    var inverted:Light {
        var copy = self
        copy.toggle()
        return copy
    }
    
    mutating func toggle() {
        switch state {
        case .On:
            state = .Off
        case .Off:
            state = .On
        case .Stuck:
            state = .Stuck
        }
    }
    
}

public extension Array where Element : LightType {
    
    public var onCount:Int {
        return filter({ $0.isOn }).count
    }
    
    public var offCount:Int {
        return filter({ $0.isOff }).count
    }
    
}

public class GameOfSanta : CustomStringConvertible, CustomPlaygroundQuickLookable {
    
    private var state:[Position:Light]
    
    public init(state: [Position:Light]) {
        self.state = state
    }
    
    public init(string: String) {
        var state:[Position:Light] = [:]
        var x = 0, y = 0
        for char in string.characters {
            switch char {
            case "#":
                state[Position(x++, y)] = Light(state: .On)
            case ".":
                state[Position(x++, y)] = Light(state: .Off)
            case "X":
                state[Position(x++, y)] = Light(state: .Stuck)
            case "\n":
                x = 0
                y++
            default: continue
            }
        }
        self.state = state
    }
    
    public var lights:[Light] {
        return Array(state.values)
    }
    
    public var rect:Rectangle {
        let first = state.keys.first!
        var x = first.x
        var y = first.y
        for pos in state.keys.dropFirst() {
            if pos.x > x { x = pos.x }
            if pos.y > y { y = pos.y }
        }
        return Rectangle(topLeft: Position(0, 0), bottomRight: Position(x, y))
    }
    
    func neighboursFor(position: Position) -> [Light] {
        var neighbours:[Light] = []
        let searchRect = Rectangle(
            topLeft: position - Position(1, 1),
            bottomRight: position + Position(1, 1)
        )
        for pos in searchRect {
            if pos == position { continue }
            if let light = state[pos] {
                neighbours.append(light)
            }
        }
        return neighbours
    }
    
    public func step() {
        var newState:[Position:Light] = [:]
        for (position, light) in state {
            let neighboursOn = neighboursFor(position).onCount
            if (light.isOn && (neighboursOn != 2 && neighboursOn != 3)) ||
                (light.isOff && neighboursOn == 3) {
                    newState[position] = light.inverted
            } else {
                newState[position] = light
            }
        }
        self.state = newState
    }
    
    public var description:String {
        var y = 0
        var result:[Character] = []
        for pos in rect {
            if pos.y != y {
                result.append("\n")
                y = pos.y
            }
            guard let light = state[pos] else { return "Invalid \(pos)" }
            switch light.state {
            case .On:
                result.append("#")
            case .Off:
                result.append(".")
            case .Stuck:
                result.append("X")
            }
        }
        return String(result)
    }
    
    var view:GameOfSantaView {
        return GameOfSantaView(game: self)
    }
    
    public func customPlaygroundQuickLook() -> PlaygroundQuickLook {
        return PlaygroundQuickLook.View(view)
    }
    
    
}


class GameOfSantaView : NSView {
    
    let lightSize:Int = 4
    let size:NSSize
    let game:GameOfSanta
    
    init(game: GameOfSanta) {
        self.game = game
        self.size = NSSize(width: lightSize, height: lightSize)
        let frame = NSRect(game.rect.scale(lightSize))
        super.init(frame: frame)
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    override func drawRect(_: NSRect) {
        drawState()
    }
    
    func drawState() {
        for (position, light) in game.state {
            let color:NSColor
            if light.isOn {
                color = NSColor.yellowColor()
            } else {
                color = NSColor.blackColor()
            }
            let rect = NSRect(origin: NSPoint(position * lightSize), size: size)
            let rectanglePath = NSBezierPath(rect: rect)
            color.setFill()
            rectanglePath.fill()
        }
    }
}



