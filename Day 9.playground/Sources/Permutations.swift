import Foundation

// https://www.objc.io/blog/2014/12/08/functional-snippet-10-permutations/
// Updated for Swift 2

extension Array {
    var decompose:(head: Array.Generator.Element, tail: [Array.Generator.Element])? {
        return (count > 0) ? (self[0], Array(self[1..<count])) : nil
    }
}

public func between<T>(x: T, _ ys: [T]) -> [[T]] {
    if let (head, tail) = ys.decompose {
        return [[x] + ys] + between(x, tail).map { [head] + $0 }
    } else {
        return [[x]]
    }
}

public func permutations<T>(xs: [T]) -> [[T]] {
    if let (head, tail) = xs.decompose {
        return permutations(tail).flatMap { between(head, $0) }
    } else {
        return [[]]
    }
}
