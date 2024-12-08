//
//  FoodRow.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/26.
//

import SwiftUI

struct FoodRow: View {
    let food: Food
    var day: Day
 
    var body: some View {
        HStack {
            
                HStack {
                    if let quantity = day.foodsEaten[food] {
                        let stringQuantity =  String(format: "%0.1f", quantity)
                        let totalCalories = String(format: "%0.0f", quantity * food.calories)
                        
                        
                      
                        VStack(alignment: .leading) {
                            
                            
                            Text(food.name)
                            
                            
                            quantity > 1.0 ?
                            Text("\(stringQuantity) \(food.servingType)s")
                                .foregroundStyle(.secondary)
                                 :
                            Text("\(stringQuantity)  \(food.servingType) ")
                                .foregroundStyle(.secondary)
                                 
                            
                            
                            
                         
                            
                        }
                        
                        Spacer()
                        
                        Text(totalCalories)
                            .foregroundStyle(.secondary)
                    }
                    
                    
                     
                        
                        
                        
                        
                    }
                    
                    
              
                }
                .overlay {
                    NavigationLink(destination: EditFoodView( day: day, food: food )) {}
                                         
                                         }
            }
        }
        
    





#Preview {
    
    FoodRow(food: Food.example, day: Day.example)
   
}
