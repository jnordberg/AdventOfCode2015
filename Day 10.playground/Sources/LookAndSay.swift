import Foundation

public func encodeLookAndSay(input: String) -> String {
    let chars = [Character](input.characters)
    var result:[Character] = []
    
    var idx = 0
    while idx < chars.count {
        let char = chars[idx]
        var num = 1
        
        while idx < chars.count - 1 && chars[idx + 1] == char {
            num++
            idx++
        }
        
        result.appendContentsOf(String(num).characters)
        result.append(char)
        
        idx++
    }
    
    return String(result)
}