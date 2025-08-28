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
    
    
    var food: Food
    var servingSize: Double
    @Relationship(inverse: \Day.foodEntries) var day: Day?
    
    enum CodingKeys: String, CodingKey {
           case food, servingSize
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

