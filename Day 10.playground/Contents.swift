import Foundation

let input = "3113322113"

var result = input
for _ in 1...40 {
    result = encodeLookAndSay(result)
    result.characters.count
}

print("Number of characters: \(result.characters.count)")
