import Foundation

let passwordCharset = [Character]("abcdefghijklmnopqrstuvwxyz".characters)
let invalidChars = Set<Character>("iol".characters)

extension Array where Element : Equatable {
    
    func rightOf(item: Element, wrapAround: Bool = false) -> Element? {
        guard var idx = indexOf(item) else { return nil }
        idx++
        if wrapAround { idx = idx % count }
        if self.indices.contains(idx) {
            return self[idx]
        }
        return nil
    }
    
}

func incrementPassword(input: String) -> String {
    var chars = [Character](input.characters)
    var idx = chars.count
    while idx-- > 0 {
        chars[idx] = passwordCharset.rightOf(chars[idx], wrapAround: true)!
        if chars[idx] != passwordCharset.first {
            break
        }
        
    }
    return String(chars)
}

func getLongestRun(input: String) -> Int {
    let chars = [Character](input.characters)
    var best = 0
    var idx = 1
    while idx < chars.count {
        var run = 1
        while idx < chars.count && chars[idx] == passwordCharset.rightOf(chars[idx - 1]) {
            run++
            idx++
        }
        if run > best {
            best = run
        }
        idx++
    }
    return best
}

func numUniqueDoubles(input: String) -> Int {
    let chars = [Character](input.characters)
    var doubles:Set<Character> = []
    var idx = -1
    while ++idx < chars.count {
        let char = chars[idx]
        if doubles.contains(char) {
            continue
        }
        var num = 1
        if idx < chars.count - 1 && chars[idx + 1] == char {
            num++
            idx++
        }
        if num >= 2 {
            doubles.insert(char)
        }
    }
    return doubles.count
}

func isValidPassword(password: String) -> Bool {
    if password.characters.contains({ invalidChars.contains($0) }) {
        return false
    }
    if getLongestRun(password) < 3 {
        return false
    }
    if numUniqueDoubles(password) < 2 {
        return false
    }
    return true
}

public func getNextValidPassword(oldPassword: String) -> String {
    var password = oldPassword
    repeat {
        password = incrementPassword(password)
    } while !isValidPassword(password)
    return password
}
