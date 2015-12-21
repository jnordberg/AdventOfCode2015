import Foundation

public extension Array {

    public var decompose:(head: Array.Generator.Element, tail: [Array.Generator.Element])? {
        return (count > 0) ? (self[0], Array(self[1..<count])) : nil
    }
    
    public func between(x: Array.Generator.Element) -> [[Array.Generator.Element]] {
        if let (head, tail) = decompose {
            return [[x] + self] + tail.between(x).map { [head] + $0 }
        } else {
            return [[x]]
        }
    }
    
    public var permutations:[[Array.Generator.Element]] {
        if let (head, tail) = decompose {
            return tail.permutations.flatMap { $0.between(head) }
        } else {
            return [[]]
        }
    }

}
