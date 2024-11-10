//
//  Day.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/10.
//

import Foundation
import SwiftData

@Model
class Day {
    
    var date : Date
    var weight: Double
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyy"
        return formatter.string(from: date)
    }
    
    var foodsEaten: [Food]
    
    
    // Sum all the foods eaten and cast the sum (Double) into an Int.
    var totalCalories: Int {
        Int(foodsEaten.reduce(0) {$0 + $1.calories})
    }
    
    
    init(date: Date, foodsEaten: [Food], weight: Double) {
        self.date = date
        self.foodsEaten = foodsEaten
        self.weight = weight
    }
    

    
    static let example = Day(
        date: Date().addingTimeInterval(-1006400),
      
        foodsEaten: [
           
            
        ],
        weight: 0.0
    )
    
  
}
           
           
            
    
    
    
    
    

