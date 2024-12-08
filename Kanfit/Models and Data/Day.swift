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
    
 
    
    var foodsEaten: [Food: Double]
    
//  For exporting our data to CSV
    var csvDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
        
    }
    
    var foodsEatentoCSV: String {
       
        var result: String = ""
        foodsEaten.forEach { food, amount in
            
            
            let foodData = "(\(food.name)  \(food.calories)  \(amount)   \(food.calories * amount)) "
           
            result += foodData
            
        }
     
        
       
        
        return result
    }
    
    

    var totalCalories: Double {
        var total: Double = 0
        foodsEaten.forEach { food, amount in
            total += food.calories * amount
            
        }
        return total
            
        }

    
    
    init(date: Date, foodsEaten: [Food: Double], weight: Double, person: Person) {
        self.date = date
        self.foodsEaten = foodsEaten
        self.weight = weight
     
  
    }
    

    
    static let example = Day(
        date: Date().addingTimeInterval(-1006400),
        foodsEaten: [Food.example: 2],
        weight: 0.0,
        person: Person.example
    )
    
  
}
           
           
            
    
    
    
    
    

