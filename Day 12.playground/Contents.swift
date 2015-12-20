import Utils

func sumObject(item: AnyObject) -> Int {
    var sum = 0
    switch item {
    case let number as Int:
        sum += number
    case let object as [String:AnyObject]:
        sum += sumObject(Array(object.values))
    case let array as [AnyObject]:
        sum += array.map { sumObject($0) }.reduce(0) { $0 + $1 }
    default: break
    }
    return sum
}

func hasRed(item: AnyObject) -> Bool {
    switch item {
    case let string as String where string == "red":
        return true
    case let object as [String:AnyObject]:
        for (key, value) in object {
            if key == "red" { return true }
            if (value as? String) == "red" { return true }
        }
    default: break
    }
    return false
}

func removeRed(item: AnyObject) -> AnyObject? {
    var rv:AnyObject?
    switch item {
    case var object as [String:AnyObject]:
        if !hasRed(item) {
            for (key, value) in object {
                object[key] = removeRed(value)
            }
            rv = object
        }
    case let array as [AnyObject]:
        let arr:[AnyObject] = array
            .map { removeRed($0) }
            .filter { $0 != nil }
            .map { $0! }
        rv = arr as AnyObject
    default:
        rv = item
    }
    return rv
}

do {
    let input = try loadResourceAsData("input")
    let json = try NSJSONSerialization.JSONObjectWithData(input, options: [])
    let part1 = sumObject(json)
    let part2 = sumObject(removeRed(json)!)
    print("Part1: \(part1) Part2: \(part2)")
} catch let error {
    print("Error: \(error)")
}
