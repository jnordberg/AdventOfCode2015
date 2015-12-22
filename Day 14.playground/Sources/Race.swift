import Cocoa

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
    
}

public class Reindeer : CustomStringConvertible {
    
    let name:String
    let speed:Int
    let runTime: Int
    let restTime: Int
    
    var energy:Int
    var position:Int = 0
    var resting:Bool = false
    var points:Int = 0
    
    public enum Error : ErrorType { case InvalidString }
    
    public init(_ name: String, _ speed: Int, _ runTime: Int, _ restTime: Int) {
        self.speed = speed
        self.runTime = runTime
        self.restTime = restTime
        self.energy = runTime
        self.name = name
    }
    
    public init(_ string: String) throws {
        let regex = try! NSRegularExpression(
            pattern: "([a-z]+) can fly ([0-9]+) .* for ([0-9]+) seconds.* ([0-9]+) seconds",
            options: [.CaseInsensitive]
        )
        let matches = regex.groupMatchesInString(string)
        if matches.count != 5 {
            // http://stackoverflow.com/a/26497229/1435777
            self.name = ""
            self.runTime = 0
            self.speed = 0
            self.restTime = 0
            self.energy = 0
            throw Error.InvalidString
        }
        self.name = matches[1]
        self.speed = Int(matches[2])!
        self.runTime = Int(matches[3])!
        self.restTime = Int(matches[4])!
        self.energy = self.runTime
    }
    
    func step() {
        if resting {
            energy++
            if energy == 0 {
                energy = runTime
                resting = false
            }
        } else {
            position += speed
            energy--
            if energy == 0 {
                energy = -restTime
                resting = true
            }
        }
    }
    
    public var description:String {
        return "\(name) \(speed)km/h \(runTime)/\(restTime) - \(position)km \(points) points"
    }
}

public class ReindeerSimulator {
    
    public let runners:[Reindeer]
    
    public init(_ runners: [Reindeer]) {
        self.runners = runners
    }
    
    public func step(delta:Int = 1) {
        for _ in 1...delta {
            for runner in runners {
                runner.step()
            }
            let sorted = runners.sort { $0.0.position > $0.1.position }
            let leaders = sorted.filter { $0.position == sorted[0].position }
            for runner in leaders {
                runner.points++
            }
        }
    }
    
    public var leader:Reindeer {
        return runners.sort { $0.0.position > $0.1.position }.first!
    }
    
    public var winner:Reindeer {
        return runners.sort { $0.0.points > $0.1.points }.first!
    }
    
}
