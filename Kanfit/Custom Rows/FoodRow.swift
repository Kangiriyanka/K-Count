//
//  FoodRow.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/26.
//

import SwiftUI

struct FoodRow: View {
    let food: Food
    let day: Day
    var body: some View {
        HStack {
            if let quantity = day.foodsEaten[food] {
                VStack(alignment: .leading) {
                    
                    
                    Text(food.name)
                    
                    
                    
                    Text(quantity > 1 ? "\(Int(quantity)) \(food.servingType)s" :"\(Int(quantity)) \(food.servingType) ").foregroundStyle(.secondary)
                }
                
                
                Spacer()
                
                Text("\(Int(food.calories * quantity))")
                    .foregroundStyle(.secondary)
            }
        }
        
    }
}




#Preview {
    FoodRow(food: Food.example, day: Day.example)
}
