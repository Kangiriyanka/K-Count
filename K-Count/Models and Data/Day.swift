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
  
    
    var formattedWeight: String {
        return String(format: "%0.1f", self.weight) 
    }
    

    @Relationship(deleteRule: .cascade) var foodEntries = [FoodEntry]()
    
    
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
    
    static func generateExamples(count: Int) -> [Day] {
        var days: [Day] = []
        let baseDate = Date()
        var weight: Double = 70.0

        for i in 0..<count {
            // Going backwards in time
            let date = baseDate.addingTimeInterval(-86400 * Double(i))

           
            weight -= Double.random(in: -0.3...0.3)

            // Random food entries
            let entries = [
                FoodEntry(food: Food.exampleFruit, servingSize: Double(Int.random(in: 1...3))),
                FoodEntry(food: Food.exampleVegetable, servingSize: Double(Int.random(in: 1...3)))
            ]

            days.append(
                Day(date: date, weight: weight, foodEntries: entries)
            )
        }

        return days
    }

 
    static let examples: [Day] = generateExamples(count: 365)
    
    @MainActor static func previewContainer() -> ModelContainer {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try! ModelContainer(for: Day.self, configurations: config)
            
            // Add all example foods
            for day in examples {
                container.mainContext.insert(day)
            }
            
            return container
    }
    
    static let emptyDay = Day(date: Date(), weight: 0.0, foodEntries: [])
    
  
}
           
           
            
    
    
    
    
    

