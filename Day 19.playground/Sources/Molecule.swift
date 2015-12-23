import Foundation

public extension MutableCollectionType where Index == Int {
    public mutating func shuffleInPlace() {
        if count < 2 { return }
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}

public func loadReplacements(input: Array<String>) -> [String:Set<String>] {
    var rv:[String:Set<String>] = [:]
    for item in input {
        let parts = item.componentsSeparatedByString(" => ")
        let from = parts[0]
        let to = parts[1]
        if rv[from] == nil { rv[from] = [] }
        rv[from]?.insert(to)
    }
    return rv
}

public func getPossibleMolecules(input: String, _ replacementMap: [String:Set<String>]) -> Set<String> {
    var idx = 0
    var combinations:Set<String> = []
    let chars = Array(input.characters)
    while idx < chars.count {
        let char = chars[idx]
        var rlen = 1
        var replacements = replacementMap[String(char)]
        if replacements == nil && idx < chars.count {
            replacements = replacementMap[String([chars[idx], chars[idx + 1]])]
            rlen++
        }
        if replacements != nil {
            let head = chars[0..<idx]
            let tail = chars[idx+rlen..<chars.count]
            for str in replacements! {
                combinations.insert(String(head + str.characters + tail))
            }
        }
        idx++
    }
    return combinations
}
