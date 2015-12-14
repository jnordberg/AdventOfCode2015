// http://adventofcode.com/day/2

import Cocoa
import Utils

struct Box : CustomStringConvertible {
    let length: Int
    let width: Int
    let height: Int

    init(dimensions: String) {
        let parts:Array<Int> = dimensions.characters
            .split { $0 == "x" }
            .map { Int(String($0))! }
        self.length = parts[0]
        self.width = parts[1]
        self.height = parts[2]
    }
    
    var description: String {
        return "\(length)x\(width)x\(height)"
    }

    var totalArea: Int {
        return 2 * length * width + 2 * width * height + 2 * height * length
    }

    var smallestSideArea: Int {
        return min(length * width, width * height, height * length)
    }
    
    var volume: Int {
        return length * width * height
    }
    
    var topPerimeter:Int {
        return length + length + width + width
    }
    
    var frontPerimeter:Int {
        return length + length + height + height
    }
    
    var sidePerimeter:Int {
        return height + height + width + width
    }
    
    var smallestPerimeter: Int {
        return min(sidePerimeter, frontPerimeter, topPerimeter)
    }
    
    var ribbonNeeded: Int {
        return smallestPerimeter + volume
    }
    
    var paperNeeded: Int {
        return self.totalArea + self.smallestSideArea
    }
}


let boxDimensions = try! loadResourceAsNewlineSeparatedArray("input")

var totalPaper = 0
var totalRibbon = 0

for dimensions in boxDimensions {
    let box = Box(dimensions: dimensions)
    totalPaper += box.paperNeeded
    totalRibbon += box.ribbonNeeded
}

print("Paper needed: \(totalPaper)\n Ribbon needed: \(totalRibbon)")


