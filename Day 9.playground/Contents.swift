import Utils

let input = try! loadResourceAsNewlineSeparatedArray("input")
var locations:Set<Location> = []

for line in input {
    var parts = line.characters.split { $0 == " " }.map { String($0) }

    var from = Location(parts[0])
    if let index = locations.indexOf(from) {
        from = locations[index]
    } else {
        locations.insert(from)
    }
    
    var to = Location(parts[2])
    if let index = locations.indexOf(to) {
        to = locations[index]
    } else {
        locations.insert(to)
    }

    var distance = Distance(parts[4])!
    
    to.addConnection(from, distance: distance)
    from.addConnection(to, distance: distance)
}

print("Locations: \(locations)")

var shortest:(Distance, [Location]) = (Distance.max, [])
var longest:(Distance, [Location]) = (Distance.min, [])

for route in permutations(Array(locations)) {
    do {
        let distance = try route.getTraveledDistance()
        if distance < shortest.0 {
            shortest = (distance, route)
        }
        if distance > longest.0 {
            longest = (distance, route)
        }
    } catch {
        
    }
}

print("Shortest path is \(shortest)")
print("Longest path is \(longest)")
