import Foundation

public typealias Happiness = Int

public class Person : Hashable, CustomStringConvertible {
    
    public let name:String
    var relations:[Person:Happiness] = [:]
    
    public enum Error : ErrorType {
        case NoRelation(Person), ParsingError
    }
    
    public init (_ name: String) {
        self.name = name
    }
    
    public var description:String {
        return name
    }
    
    public var hashValue:Int {
        return name.hashValue
    }
    
    public func addRelationTo(person:Person, _ happiness:Happiness) {
        assert(relations[person] == nil, "Already have relation to \(person)")
        relations[person] = happiness
    }
    
    public func happinessWithNeighbours(left: Person, right: Person) throws -> Happiness {
        if relations[left] == nil { throw Error.NoRelation(left) }
        if relations[right] == nil { throw Error.NoRelation(right) }
        return relations[left]! + relations[right]!
    }
}

public func ==(left:Person, right:Person) -> Bool {
    return left.name == right.name
}

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

public extension Array where Element: Person {
    
    public init(relations:String) throws {
        let relationExpression = try NSRegularExpression(
            pattern: "([a-z]+) would (lose|gain) ([0-9]+) happiness .*? to ([a-z]+)",
            options: [.CaseInsensitive]
        )
        var persons:Set<Person> = []
        for relation in relations.componentsSeparatedByString("\n") {
            let matches = relationExpression.groupMatchesInString(relation)
            if matches.count != 5 { throw Person.Error.ParsingError }
            var personA = Person(matches[1])
            var personB = Person(matches[4])
            guard var happiness = Happiness(matches[3]) else { throw Person.Error.ParsingError }
            if matches[2] == "lose" {
                happiness = -happiness
            }
            if let index = persons.indexOf(personA) {
                personA = persons[index]
            } else {
                persons.insert(personA)
            }
            if let index = persons.indexOf(personB) {
                personB = persons[index]
            } else {
                persons.insert(personB)
            }
            personA.addRelationTo(personB, happiness)
        }
        self.init(persons as! Set<Element>)
    }
    
    public var totalHappiness:Happiness {
        var happiness:Happiness = 0
        for (idx, person) in enumerate() {
            let left = self[(count + idx - 1) % count]
            let right = self[(idx + 1) % count]
            happiness += try! person.happinessWithNeighbours(left, right: right)
        }
        return happiness
    }

}

public func getBestArrangement(persons:[Person]) -> (Happiness, [Person])  {
    let permutations = persons.permutations
    var best:(Happiness, [Person]) = (permutations.first!.totalHappiness, permutations.first!)
    for arrangement in permutations.dropFirst() {
        let happiness = arrangement.totalHappiness
        if happiness > best.0 {
            best = (happiness, arrangement)
        }
    }
    return best
}
