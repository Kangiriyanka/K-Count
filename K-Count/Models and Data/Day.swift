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
    @Attribute(.unique) var date : Date
    var weight: Double
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyy"
        return formatter.string(from: date)
    }
    var formattedChartDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter.string(from: date)
    }
    
    var formattedWeight: String {
        return String(format: "%0.1f", self.weight) 
    }
    
    // No more hidden foodEntries hidden around
    @Relationship(deleteRule: .cascade) var foodEntries = [FoodEntry]()
    
//  For exporting our data to CSV
    var csvDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
        
    }
    
    var foodsEatentoCSV: String {
       
        var result: String = ""
        foodEntries.forEach { entry in
            
            
            let foodData = "(\(entry.food.name)  \(entry.food.calories)  \(entry.servingSize)   \(entry.food.calories * entry.servingSize)) "
            result += foodData
            
        }
     
        return result
    }
    
    

    var totalCalories: Double {
        var total: Double = 0
        foodEntries.forEach { entry in
            total += entry.food.calories * entry.servingSize
            
        }
        return total
            
        }

    
    
    init(date: Date, weight: Double, foodEntries : [FoodEntry] ) {
        self.date = date
        self.foodEntries = foodEntries
        self.weight = weight
     
  
    }
    

    
    static let example = Day(
        date: Date().addingTimeInterval(-1006400),
        weight: 0.0,
        foodEntries: [
       
            FoodEntry(food: Food.exampleFruit, servingSize: 2),
            FoodEntry(food: Food.exampleVegetable, servingSize: 3)
          
        ],
     

    )
    
    static let examples: [Day] = [
            Day(
                date: Date().addingTimeInterval(-86400 * 3),
                weight: 70.5,
                foodEntries: [
                    FoodEntry(food: Food.exampleFruit, servingSize: 2),
                    FoodEntry(food: Food.exampleVegetable, servingSize: 1)
                ]
            ),
            Day(
                date: Date().addingTimeInterval(-86400 * 2),
                weight: 70.0,
                foodEntries: [
                    FoodEntry(food: Food.exampleFruit, servingSize: 1),
                    FoodEntry(food: Food.exampleVegetable, servingSize: 2)
                ]
            ),
            Day(
                date: Date().addingTimeInterval(-86400),
                weight: 69.8,
                foodEntries: [
                    FoodEntry(food: Food.exampleFruit, servingSize: 3),
                    FoodEntry(food: Food.exampleVegetable, servingSize: 1)
                ]
            ),
            Day(
                date: Date(),
                weight: 69.7,
                foodEntries: [
                    FoodEntry(food: Food.exampleFruit, servingSize: 2),
                    FoodEntry(food: Food.exampleVegetable, servingSize: 3)
                ]
            )
        ]
    
    static let emptyDay = Day(date: Date(), weight: 0.0, foodEntries: [])
    
  
}
           
           
            
    
    
    
    
    

