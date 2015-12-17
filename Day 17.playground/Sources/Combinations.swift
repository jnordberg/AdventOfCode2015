import Foundation

public extension Range {
    
    public func toArray() -> [Element] {
        var result: [Element] = []
        for i in self {
            result.append(i)
        }
        return result
    }
}

public extension Array {
    
    // https://github.com/ayn/ExSwift/blob/Swift-2.0/ExSwift/Array.swift
    public func combinations(length: Int) -> [[Element]] {
        if length < 0 || length > self.count {
            return []
        }
        var indexes: [Int] = (0..<length).toArray()
        var combinations: [[Element]] = []
        let offset = self.count - indexes.count
        while true {
            var combination: [Element] = []
            for index in indexes {
                combination.append(self[index])
            }
            combinations.append(combination)
            var i = indexes.count - 1
            while i >= 0 && indexes[i] == i + offset {
                i--
            }
            if i < 0 {
                break
            }
            i++
            let start = indexes[i-1] + 1
            for j in (i-1)..<indexes.count {
                indexes[j] = start + j - i + 1
            }
        }
        return combinations
    }
   
    
    public func allCombinations() -> [[Element]] {
        var result:[[Element]] = []
        for i in 1..<count {
            result += self.combinations(i)
        }
        return result + [self]
    }

}
