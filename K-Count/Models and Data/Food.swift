//
//  Food.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/10.
//

import Foundation
import SwiftData

@Model
class Food: Codable {
    
    var name: String
    var calories: Double
    var servingType: String
    
    enum CodingKeys: String, CodingKey {
           case name, calories, servingType
       }
    
    
    static let example = Food(name: "Reese Peanut Butter Cup", calories: 150, servingType: "piece")
    static let another_example =  Food(name: "Steak", calories: 3, servingType: "gram")
    static let exampleFruit = Food(name: "Apple", calories: 95, servingType: "piece")
    static let exampleVegetable = Food(name: "Carrot", calories: 25, servingType: "piece")
    static let exampleDrink = Food(name: "Orange Juice", calories: 110, servingType: "cup")
    static let exampleSnack = Food(name: "Potato Chip", calories: 10, servingType: "chip")
    static let exampleGrain = Food(name: "Rice", calories: 205, servingType: "cup")
    static let exampleProtein = Food(name: "Chicken Breast", calories: 165, servingType: "100 gram")
    static let exampleDairy = Food(name: "Cheddar Cheese", calories: 113, servingType: "slice")
    static let exampleDessert = Food(name: "Chocolate Cake", calories: 235, servingType: "slice")
    static let exampleSeafood = Food(name: "Salmon", calories: 208, servingType: "100 gram")
    static let exampleBreakfast = Food(name: "Scrambled Egg", calories: 100, servingType: "egg")
    
    static let previewExamples: [Food] = [
            example,
            another_example,
            exampleFruit,
            exampleVegetable,
            exampleDrink,
            exampleSnack,
            exampleGrain,
            exampleProtein,
            exampleDairy,
            exampleDessert,
            exampleSeafood,
            exampleBreakfast
        ]
    
    @MainActor static func previewContainer() -> ModelContainer {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try! ModelContainer(for: Food.self, configurations: config)
            
            // Add all example foods
            for food in previewExamples {
                container.mainContext.insert(food)
            }
            
            return container
    }
    
    
    
    
    init(name: String, calories: Double, servingType: String) {
        self.name = name
        self.calories = calories
        self.servingType = servingType
    }
    
    
    required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.name = try container.decode(String.self, forKey: .name)
            self.calories = try container.decode(Double.self, forKey: .calories)
            self.servingType = try container.decode(String.self, forKey: .servingType)
        }
    
    
    func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(name, forKey: .name)
            try container.encode(calories, forKey: .calories)
            try container.encode(servingType, forKey: .servingType)
        }
    
}
