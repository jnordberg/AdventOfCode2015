import Foundation


public protocol GenomeType {
    static func random() -> Self
    func mutate(probability:Float) -> Self
    func cross(other: Self) -> Self
}

public protocol Genetic {
    typealias Genome: GenomeType
    init(genome: Genome)
    var genome:Genome { get }
    var fitness:Int { get }
}

public class Evolution<T: Genetic> {
    
    public let populationSize:Int
    public let mutationProbability:Float
    
    public var population:Array<T> = []
    
    public init(populationSize: Int, mutationProbability: Float = 0.1) {
        self.populationSize = populationSize
        self.mutationProbability = mutationProbability
        for _ in 1...populationSize {
            population.append(T(genome: T.Genome.random()))
            population.sortInPlace { $0.0.fitness > $0.1.fitness }
        }
    }
    
    public func step() {
        let parentGenes = population[0..<2].map { $0.genome }
        var nextGeneration:[T.Genome] = []
        
        for _ in 0..<populationSize - 1 {
            nextGeneration.append(parentGenes[0].cross(parentGenes[1]))
        }
        
        nextGeneration[populationSize - 2] = T.Genome.random()
        
        population = nextGeneration
            .map { $0.mutate(mutationProbability) }
            .map { T(genome: $0) }
        
        population.sortInPlace { $0.0.fitness > $0.1.fitness }
    }
    
    public var alpha:T {
        return population[0]
    }
    
}
