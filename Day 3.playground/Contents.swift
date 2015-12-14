// http://adventofcode.com/day/3

import Utils

// Position struct moved out to Sources since it was slowing down the playground execution

func move(instruction:Character, inout pos:Position, inout visited:[Position:Int]) {
    switch instruction {
    case ">":
        pos.x += 1
    case "<":
        pos.x -= 1
    case "v":
        pos.y += 1
    case "^":
        pos.y -= 1
    default: break
    }
    if let numVisits = visited[pos] {
        visited[pos] = numVisits + 1
    } else {
        visited[pos] = 1
    }
}


let instructions = try! loadResourceAsString("input")

var housesVisited:[Position:Int] = [:]
var santaPos = Position(x: 0, y: 0)
var robotPos = Position(x: 0, y: 0)

for (index, instruction) in instructions.characters.enumerate() {
    var pos:Position
    if index % 2 == 0 {
        move(instruction, pos: &santaPos, visited: &housesVisited)
    } else {
        move(instruction, pos: &robotPos, visited: &housesVisited)
    }
}

print("Santa and his robot visited \(housesVisited.values.count) houses")
