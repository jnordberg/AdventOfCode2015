import Cocoa
import Utils


struct NiceString {
    let string:String
    
    private let vowels = "aeiou"
    private let naughtyWords = [
        "ab", "cd", "pq", "xy"
    ]

    var vowelCount:Int {
        var count = 0
        for char in string.characters {
            if vowels.characters.contains(char) {
                count++
            }
        }
        return count
    }
    
    var hasRepeating:Bool {
        var lastChar = string.characters.first
        for char in string.characters.dropFirst() {
            if char == lastChar {
                return true
            }
            lastChar = char
        }
        return false
    }

    var hasRepeatingWithGap:Bool {
        var chars = [Character](string.characters)
        for idx in 1..<chars.count-1 {
            let prev = chars[idx - 1]
            let next = chars[idx + 1]
            if next == prev {
                return true
            }
        }
        return false
    }
    
    var hasNaughtyWords:Bool {
        for word in naughtyWords {
            if string.containsString(word) {
                return true
            }
        }
        return false
    }
    
    var hasNonOverlappingPairs:Bool {
        var lookup:[String:Bool] = [:]
        var chars = [Character](string.characters)
        for idx in 1..<chars.count-1 {
            let prev = chars[idx - 1]
            let char = chars[idx]
            let next = chars[idx + 1]
            let pair = String([prev, char])
            let nextPair = String([char, next])
            if pair == nextPair {
                continue
            }
            if lookup[pair] != nil {
                return true
            } else {
                lookup[pair] = true
            }
            if idx == chars.count - 2 && lookup[nextPair] != nil {
                return true
            }
        }
        return false
    }
    
    var isNice:Bool {
        return vowelCount >= 3 && hasRepeating && !hasNaughtyWords
    }
    
    var isTheNewNice:Bool {
        return hasNonOverlappingPairs && hasRepeatingWithGap
    }
    
    
}

let input = try! loadResourceAsNewlineSeparatedArray("input")
let strings = input.map { NiceString(string: $0) }
    
let niceStrings = strings.filter { $0.isNice }
let newNiceStrings = strings.filter { $0.isTheNewNice }

print("\(niceStrings.count) strings are nice")
print("\(newNiceStrings.count) strings are the new nice")

