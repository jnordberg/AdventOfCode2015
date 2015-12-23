import Utils


let replacements = loadReplacements(try! loadResourceAsNewlineSeparatedArray("input"))
let molecule = try! loadResourceAsString("starting")

let result = getPossibleMolecules(molecule, replacements)
print("There are \(result.count) possible molecules")

var reverseMap = Dictionary<String,String>()
for replacement in replacements {
    for item in replacement.1 {
        reverseMap[item] = replacement.0
    }
}
var reverse = Array(reverseMap)

var mol = molecule
var count = 0
var tries = 0
while mol != "e" {
    reverse.shuffleInPlace()
    var found = false
    for (from, to) in reverse {
        tries++
        while let range = mol.rangeOfString(from, options: []) {
            mol.replaceRange(range, with: to)
            count++
            found = true
        }
        if found { break }
    }
    if !found {
        mol = molecule
        count = 0
        tries = 0
    }
}

print("Reverse path length: \(count)")





