import Utils

let input = try! loadResourceAsNewlineSeparatedArray("input")

//let containers = ContainerList([Container(20), Container(15), Container(10), Container(5), Container(5)])
let containers = ContainerList(input)!

let sortedContainers = containers.sort { $0.volume > $1.volume }

sortedContainers

let combinations = sortedContainers.combinationsFor(150)

combinations.count

let bestCombination = combinations[0]

let topCombinations = combinations.filter { $0.list.count == bestCombination.list.count }

topCombinations

topCombinations.count












