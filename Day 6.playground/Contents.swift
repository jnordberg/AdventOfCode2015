
import Utils

var grid = LightGrid(width: 1000, height: 1000)
let input = try! loadResourceAsNewlineSeparatedArray("input")

for cmdString in input {
    let command = try! Command(cmdString)
    try! grid.runCommand(command)
}

print("After running all the commands there are \(grid.onCount) lights on and the total brightness is \(grid.totalBrightness)")
