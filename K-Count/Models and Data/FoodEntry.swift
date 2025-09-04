//
//  FoodEntries.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2025/07/07.
//

import SwiftUI
import SwiftData

@Model
class FoodEntry: Codable {
    
    
    @Attribute(.unique) var id: UUID = UUID()
    /// Entries reference to Foods and belong inside Days.
    /// Day is optional, because we need to be able to create FoodEntries before directly attaching them todays.
    /// The relationships should only be specified on  one side, and they're in the parent.
    var day: Day?
    var food: Food?
  
    var servingSize: Double
    

    
    enum CodingKeys: String, CodingKey {
           case food, servingSize
       }
    
    var totalCalories: Double {
        guard let food = food else {
            return 0 // or some default value if food is nil
        }
        return food.calories * servingSize
    }
    
    
    init(food: Food, servingSize: Double) {
        
        self.food = food
        self.servingSize = servingSize
    }
    
    required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.food = try container.decode(Food.self, forKey: .food)
            self.servingSize = try container.decode(Double.self, forKey: .servingSize)
        }
    
    
    func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(food, forKey: .food)
            try container.encode(servingSize, forKey: .servingSize)

        }
    
    
    static let example = FoodEntry(food: .example, servingSize: 100.0)
  
}

