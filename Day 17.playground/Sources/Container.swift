import Foundation
import Cocoa

public typealias Volume = UInt16

public struct Container : CustomStringConvertible, Hashable, CustomPlaygroundQuickLookable {
    public let volume:Volume
    
    public init(_ vol:Volume) {
        volume = vol
    }
    
    public init?(_ string:String) {
        if let vol = Volume(string) {
            volume = vol
        } else {
            return nil
        }
    }
    
    public var description:String {
        return "\(volume)L"
    }
    
    public var hashValue:Int {
        return Int(volume)
    }
    
    var view:NSView {
        return ContainerView(container: self)
    }
    
    public func customPlaygroundQuickLook() -> PlaygroundQuickLook {
        return PlaygroundQuickLook.View(view)
    }
    
}

public func == (left: Container, right: Container) -> Bool { return left.volume == right.volume }

class ContainerView : NSView {
    
    let container:Container
    let size:CGFloat

    let strokeColor = NSColor(calibratedRed: 0.359, green: 0.611, blue: 0.623, alpha: 1)
    let gradientColor = NSColor(calibratedRed: 0.844, green: 1, blue: 0.992, alpha: 1)
    let gradientColor2 = NSColor(calibratedRed: 0.387, green: 0.874, blue: 0.918, alpha: 1)
    
    init(container: Container) {
        size = fmax(log(CGFloat(container.volume + 1)) * 20, 40)
        let frame = NSMakeRect(0, 0, size, size)
        self.container = container
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    override func drawRect(dirtyRect: NSRect) {
        self.drawCanvas1(frame: self.bounds)
    }

    func drawCanvas1(frame frame: NSRect = NSMakeRect(0, 0, 100, 100)) {
        //// Gradient Declarations
        let gradient = NSGradient(colors: [gradientColor, gradientColor.blendedColorWithFraction(0.5, ofColor: gradientColor2)!, gradientColor2], atLocations: [0.0, 0.55, 1.0], colorSpace: NSColorSpace.genericRGBColorSpace())!
        
        //// Variable Declarations
        let input: String = container.description
        let fontSize: CGFloat = size / 4
        
        //// Rectangle Drawing
        let rectanglePath = NSBezierPath(rect: NSMakeRect(frame.minX + 5.25, frame.minY + 5.25, frame.width - 10, frame.height - 10))
        gradient.drawInBezierPath(rectanglePath, angle: -90)
        strokeColor.setStroke()
        rectanglePath.lineWidth = 0.5
        rectanglePath.stroke()
        
        //// Text Drawing
        let textRect = NSMakeRect(frame.minX + 5, frame.minY + 5, frame.width - 10, frame.height - 10)
        let textStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        textStyle.alignment = .Center
        
        let textFontAttributes = [NSFontAttributeName: NSFont.systemFontOfSize(fontSize), NSForegroundColorAttributeName: NSColor.blackColor(), NSParagraphStyleAttributeName: textStyle]
        
        let textTextHeight: CGFloat = NSString(string: input).boundingRectWithSize(NSMakeSize(textRect.width, CGFloat.infinity), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: textFontAttributes).size.height
        let textTextRect: NSRect = NSMakeRect(textRect.minX, textRect.minY + (textRect.height - textTextHeight) / 2, textRect.width, textTextHeight)
        NSGraphicsContext.saveGraphicsState()
        NSRectClip(textRect)
        NSString(string: input).drawInRect(NSOffsetRect(textTextRect, 0, 1), withAttributes: textFontAttributes)
        NSGraphicsContext.restoreGraphicsState()
    }
    
}

class ContainerListView : NSView {
    
    let containers:ContainerList
    
    init(containers: ContainerList) {
        self.containers = containers
        super.init(frame: NSRect(x: 0, y: 0, width: 10, height: 10))
        for container in containers {
            self.addSubview(container.view)
        }
        self.layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    override func layout() {
        super.layout()
        var x:CGFloat = 0
        var maxY:CGFloat = 0
        for view in subviews {
            var frame = view.frame
            frame.origin.x = x
            view.frame = frame
            x += frame.width + 10
            if frame.height > maxY {
                maxY = frame.height
            }
        }
        self.frame = NSRect(x: 0, y: 0, width: x, height: maxY)
    }

}

// https://openradar.appspot.com/23255436
// extension Array: CustomPlaygroundQuickLookable where Element: ContainerType {
public struct ContainerList: SequenceType, Indexable, CustomPlaygroundQuickLookable {
    
    public typealias ListType = Array<Container>
    public typealias Index = ListType.Index
    public typealias _Element = ListType._Element
    public typealias Generator = ListType.Generator
    
    public let list:ListType
    
    public init(_ containers: ListType) {
        list = containers
    }
    
    public init?(_ containers: Array<String>) {
        var tmp = Array<Container>()
        for string in containers {
            if let container = Container(string) {
                tmp.append(container)
            } else {
                return nil
            }
        }
        list = tmp
    }
    
    public func generate() -> ContainerList.Generator {
        return list.generate()
    }
    
    public func sort(@noescape isOrderedBefore: (Generator.Element, Generator.Element) -> Bool) -> ContainerList {
        return ContainerList(list.sort(isOrderedBefore))
    }
    
    public func combinationsFor(volume: Volume) -> [ContainerList] {
        let combos = list.allCombinations()
                .filter { $0.reduce(0) { $0 + $1.volume } == volume }
                .map { ContainerList($0) }
        return combos
    }
    
    
    public var startIndex: Index { return list.startIndex }
    public var endIndex: Index { return list.endIndex }
    public subscript (position: Index) -> _Element { return list[position] }
    
    var view:NSView {
        return ContainerListView(containers: self)
    }
    
    public func customPlaygroundQuickLook() -> PlaygroundQuickLook {
        return PlaygroundQuickLook.View(view)
    }
    
    var first:_Element? { return list.first }
    var last:_Element? { return list.last }

}
