import Foundation
import Utils

func unescapeString(input: String) -> String {
    var result:[Character] = []
    let chars = [Character](input.characters)
    var idx = 1
    while idx < chars.count-1 {
        let char = chars[idx]
        if char == "\\" {
            let next = chars[idx + 1]
            if next == "x" {
                let charCode = Int(strtoul(String([chars[idx + 2], chars[idx + 3]]), nil, 16))
                result.append(Character(UnicodeScalar(charCode)))
                idx += 4
                continue
            }
            result.append(next)
            idx += 2
            continue
        }
        result.append(char)
        idx++
    }
    return String(result)
}

func escapeString(input: String) -> String {
    let chars = [Character](input.characters)
    var result:[Character] = []
    let escape:Set<Character> = [
        "\"", "\\"
    ]
    result.append("\"")
    for char in chars {
        if escape.contains(char) {
            result.append("\\")
        }
        result.append(char)
    }
    result.append("\"")
    return String(result)
}


var totalChars = 0
var totalUnescapedChars = 0
var totalDoubleEscapedChars = 0
var difference = 0
var doubleDifference = 0

let input = try! loadResourceAsNewlineSeparatedArray("input")

for escapedString in input {
    let unescapedString = unescapeString(escapedString)
    let doubleEscapedString = escapeString(escapedString)
    
    totalChars += escapedString.characters.count
    totalUnescapedChars += unescapedString.characters.count
    totalDoubleEscapedChars += doubleEscapedString.characters.count
    difference = totalChars - totalUnescapedChars
    doubleDifference = totalDoubleEscapedChars - totalChars
}

print("Escaped: \(totalChars) Unescaped: \(totalUnescapedChars) Difference: \(difference)")
print("Escaped: \(totalChars) Double escaped: \(totalDoubleEscapedChars) Difference: \(doubleDifference)")
