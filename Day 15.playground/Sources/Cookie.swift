import Foundation

public extension Array {
    
    public var decompose:(head: Element, tail: [Element])? {
        return (count > 0) ? (self[0], Array(self[1..<count])) : nil
    }
    
    public var random:Element {
        let idx = arc4random_uniform(UInt32(count))
        return self[Int(idx)]
    }
    
}

public extension Dictionary {
    
    public var random:Element {
        return Array(self).random
    }
    
}

public extension Float {
    
    public static var random:Float {
        return (Float(arc4random()) / Float(UINT32_MAX))
    }
    
}

public struct Properties {
    
    public static let Zero = Properties(capacity: 0, durability: 0, flavor: 0, texture: 0, calories: 0)
    
    let capacity:Int
    let durability:Int
    let flavor:Int
    let texture:Int
    let calories:Int
    
}

public func * (left:Properties, right:Int) -> Properties {
    return Properties(
        capacity: left.capacity * right,
        durability: left.durability * right,
        flavor: left.flavor * right,
        texture: left.texture * right,
        calories: left.calories * right
    )
}

public func + (left:Properties, right:Int) -> Properties {
    return Properties(
        capacity: left.capacity + right,
        durability: left.durability + right,
        flavor: left.flavor + right,
        texture: left.texture + right,
        calories: left.calories + right
    )
}

public func + (left:Properties, right:Properties) -> Properties {
    return Properties(
        capacity: left.capacity + right.capacity,
        durability: left.durability + right.durability,
        flavor: left.flavor + right.flavor,
        texture: left.texture + right.texture,
        calories: left.calories + right.calories
    )
}

public class Ingredient : CustomStringConvertible, Hashable {
    
    let name:String
    let properties:Properties
    
    public init(_ string: String) {
        let parts = string.componentsSeparatedByString(": ")
        let name = parts[0]
        let properties = parts[1].componentsSeparatedByString(", ")
            .map { $0.componentsSeparatedByString(" ") }
        var lookup:[String:Int] = [:]
        for prop in properties {
            lookup[prop[0]] = Int(prop[1])
        }
        self.name = name
        self.properties = Properties(
            capacity: lookup["capacity"]!,
            durability: lookup["durability"]!,
            flavor: lookup["flavor"]!,
            texture: lookup["texture"]!,
            calories: lookup["calories"]!
        )
    }
    
    public var description:String {
        return name
    }
    
    public var hashValue:Int {
        return name.hashValue
    }
    
}

public func == (left: Ingredient, right: Ingredient) -> Bool {
    return left.name == right.name
}

public typealias Amount = Int

public struct CookieGenome : GenomeType {
    let ingredients:[Ingredient:Amount]
    
    public static var availableIngredients:[Ingredient] = []
    public static var weight:Int = 100
    
    public static func random() -> CookieGenome {
        var ingredients:[Ingredient:Amount] = [:]
        for _ in 1...weight {
            let ingredient = availableIngredients.random
            if let count = ingredients[ingredient] {
                ingredients[ingredient] = count + 1
            } else {
                ingredients[ingredient] = 1
            }
        }
        return CookieGenome(ingredients: ingredients)
    }
    
    public init(ingredients: [Ingredient:Amount]) {
        self.ingredients = ingredients
    }
    
    public init(list: [Ingredient]) {
        var ingredients:[Ingredient:Amount] = [:]
        for ingredient in list {
            if let count = ingredients[ingredient] {
                ingredients[ingredient] = count + 1
            } else {
                ingredients[ingredient] = 1
            }
        }
        self.ingredients = ingredients
    }
    
    var list:[Ingredient] {
        var list:[Ingredient] = []
        for (ingredient, amount) in ingredients {
            for _ in 0..<amount {
                list.append(ingredient)
            }
        }
        return list
    }
    
    public func mutate(probability: Float) -> CookieGenome {
        var list = self.list
        for i in 0..<CookieGenome.weight {
            if Float.random < probability {
                list[i] = CookieGenome.availableIngredients.random
            }
        }
        return CookieGenome(list: list)
    }
    
    public func cross(other: CookieGenome) -> CookieGenome {
        let a = self.list
        let b = other.list
        var list:[Ingredient] = []
        for i in 0..<CookieGenome.weight {
            if Float.random > 0.5 {
                list.append(a[i])
            } else {
                list.append(b[i])
            }
        }
        return CookieGenome(list: list)
    }
    
}

public class Cookie : Genetic, CustomStringConvertible {
    
    public typealias Genome = CookieGenome
    
    public let genome:Genome
    
    public required init(genome: Genome) {
        self.genome = genome
    }

    lazy var properties:Properties = {
        var properties = Properties.Zero
        for (ingredient, amount) in self.genome.ingredients {
            properties = properties + ingredient.properties * amount
        }
        return properties
    }()
    
    public var fitness:Int {
        return properties.capacity * properties.durability * properties.flavor * properties.texture
    }
    
    public var description:String {
        return genome.ingredients.description
    }
    
}

public class CalorieCookie : Cookie {
    
    override public var fitness:Int {
        if properties.calories != 500 {
            return 0
        } else {
	        return super.fitness
        }
    }

}
