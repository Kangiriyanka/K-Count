//
//  FoodEntries.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2025/07/07.
//

import SwiftUI
import SwiftData

@Model
class FoodEntry {
    
    
    var food: Food
    var servingSize: Double
    @Relationship(inverse: \Day.foodEntries) var day: Day?
    
    
    init(food: Food, servingSize: Double) {
        
        self.food = food
        self.servingSize = servingSize
    }
    
    
    static let example = FoodEntry(food: .example, servingSize: 100.0)
  
}

