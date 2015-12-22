
import Utils

let ingredients = try! loadResourceAsNewlineSeparatedArray("input").map { Ingredient($0) }
//let ingredients = try! loadResourceAsNewlineSeparatedArray("overkill").map { Ingredient($0) }

CookieGenome.availableIngredients = ingredients
//CookieGenome.weight = 1000

let iters = 5
let sim = Evolution<Cookie>(populationSize: 20, mutationProbability: 0.02)
//let sim = Evolution<CalorieCookie>(populationSize: 20, mutationProbability: 0.02)
var best = sim.alpha

for _ in 1...iters {
    sim.step()
    let fitness = sim.alpha.fitness
    if fitness > best.fitness {
        best = sim.alpha
        sim.alpha.fitness
    }
}

print("Best: \(best) \(best.fitness)") // Solution part1: 18965440 part2: 15862900
