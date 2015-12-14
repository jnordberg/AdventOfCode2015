// http://adventofcode.com/day/1

import Cocoa
import Utils

let instructions = try! loadResourceAsString("input")

var currentFloor = 0
var instructionIndex = 0
var basementIndex:Int?

for char in instructions.characters {
    var move: Int
    switch char {
    case ")":
        move = -1
    case "(":
        move = 1
    default:
        continue
    }
    instructionIndex++
    currentFloor += move
    if basementIndex == nil && currentFloor == -1 {
        basementIndex = instructionIndex
    }
}


print("Santa arrived on floor \(currentFloor) and entered the basement at position \(basementIndex!)")
