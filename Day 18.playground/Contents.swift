import Utils

//let input = try! loadResourceAsString("input")
let input = try! loadResourceAsString("input_part2")

let sim = GameOfSanta(string: input)

let numSteps = 100

for _ in 1...numSteps {
    sim.step()
}

print("Number of lights on after \(numSteps) steps: \(sim.lights.onCount)")

// solution part 1: 768





