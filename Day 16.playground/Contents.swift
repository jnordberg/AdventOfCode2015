import Utils

public extension NSRegularExpression {
    
    public func groupMatchesInString(string: String, options:NSMatchingOptions = [], var range: NSRange? = nil) -> [String] {
        if range == nil { range = NSMakeRange(0, string.characters.count) }
        let matches = matchesInString(string, options: options, range: range!)
        var result:[String] = []
        for match in matches {
            for group in 0..<match.numberOfRanges {
                result.append((string as NSString).substringWithRange(match.rangeAtIndex(group)))
            }
        }
        return result
    }
    
    convenience init(_ pattern: String) throws {
        try self.init(pattern: pattern, options: [])
    }
    
}

struct Sue {

    let number:Int?

    let children:Int?
    let cats:Int?
    let samoyeds:Int?
    let pomeranians: Int?
    let akitas: Int?
    let vizslas: Int?
    let goldfish: Int?
    let trees: Int?
    let cars: Int?
    let perfumes: Int?

    subscript(key: String) -> Int? {
        switch key {
            case "children": return children
            case "cats": return cats
            case "samoyeds": return samoyeds
            case "pomeranians": return pomeranians
            case "akitas": return akitas
            case "vizslas": return vizslas
            case "goldfish": return goldfish
            case "trees": return trees
            case "cars": return cars
            case "perfumes": return perfumes
            default: assertionFailure("Invalid key \(key)")
        }
        return nil
    }

}

extension Sue {

    init(string: String) {
        let regex = try! NSRegularExpression("([a-z]+: [0-9]+)")
        let matches = regex.groupMatchesInString(string).map { $0.componentsSeparatedByString(": ") }
        var lookup:[String:Int] = [:]
        for match in matches {
            lookup[match[0]] = Int(match[1])!
        }
        self.children = lookup["children"]
        self.cats = lookup["cats"]
        self.samoyeds = lookup["samoyeds"]
        self.pomeranians = lookup["pomeranians"]
        self.akitas = lookup["akitas"]
        self.vizslas = lookup["vizslas"]
        self.goldfish = lookup["goldfish"]
        self.trees = lookup["trees"]
        self.cars = lookup["cars"]
        self.perfumes = lookup["perfumes"]
        self.number = Int(try! NSRegularExpression("Sue ([0-9]+):").groupMatchesInString(string)[1])
    }
}

infix operator ~= { associativity right }
infix operator ~<>= { associativity right }

func ~= (left: Sue, right: Sue) -> Bool {
    for key in ["children", "cats", "samoyeds", "pomeranians", "akitas", "vizslas", "goldfish", "trees", "cars", "perfumes"] {
        if left[key] != nil && right[key] != nil && left[key] != right[key] {
            return false
        }
    }
    return true
}

func ~<>= (left: Sue, right: Sue) -> Bool {
    for key in ["children", "samoyeds", "akitas", "vizslas", "cars", "perfumes"] {
        if left[key] != nil && right[key] != nil && left[key] != right[key] {
            return false
        }
    }
    for key in ["cats", "trees"] {
        if left[key] != nil && right[key] != nil && left[key] <= right[key] {
            return false
        }
    }
    for key in ["goldfish", "pomeranians"] {
        if left[key] != nil && right[key] != nil && left[key] >= right[key] {
            return false
        }
    }
    return true
}

let correctAunt = Sue(
    number: nil,
    children: 3,
    cats: 7,
    samoyeds: 2,
    pomeranians: 3,
    akitas: 0,
    vizslas: 0,
    goldfish: 5,
    trees: 3,
    cars: 2,
    perfumes: 1
)

let aunts = try! loadResourceAsNewlineSeparatedArray("input").map(Sue.init)

//let matching = aunts.filter { $0 ~= correctAunt }
let matching = aunts.filter { $0 ~<>= correctAunt }

assert(matching.count == 1, "Should have found 1 aunt")

print(matching)

