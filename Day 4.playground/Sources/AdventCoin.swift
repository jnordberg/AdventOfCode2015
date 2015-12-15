
import Foundation

public func findNonce(key: String, difficulty: Int = 2) -> Int {
    var needle = ""
    for _ in 0..<difficulty {
        needle += "0"
    }
    let digestLen = Int(ceil(Float(difficulty) / 2))
    for i in 0..<Int.max {
        let bytes = [UInt8]("\(key)\(i)".utf8)
        let hash = MD5(bytes).calculate()
        let digest = NSMutableString()
        for i in 0..<digestLen {
            digest.appendFormat("%02x", hash[i])
        }
        if digest.substringToIndex(difficulty) == needle {
            return i
        }
    }
    return -1
}
