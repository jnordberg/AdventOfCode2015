import Cocoa
import Utils

let runners = try! loadResourceAsNewlineSeparatedArray("input").map { try Reindeer($0) }
let simulator = ReindeerSimulator(runners)

simulator.step(2503)

print("The leader is: \(simulator.leader)")
print("The winner is: \(simulator.winner)")
