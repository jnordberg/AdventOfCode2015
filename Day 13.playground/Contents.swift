import Utils

var persons = try! Array<Person>(relations: loadResourceAsString("input"))

let me = Person("Johan")

for person in persons {
    me.addRelationTo(person, 0)
    person.addRelationTo(me, 0)
}
persons.append(me)

let (happiness, arrangement) = getBestArrangement(persons)

print("Best seating arrangement is: \(arrangement), resulting in a total well-being of: \(happiness)")
