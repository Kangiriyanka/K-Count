//
//  FoodsInCartView.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/22.
//

import SwiftUI

struct FoodsAddedView: View {
    @Binding var foodsAdded: [Food: Double]
    
    var body: some View {
        
        if foodsAdded.isEmpty {
            Text("Click a food to add it").italic()
        }
       
    
            
                
                ForEach(Array(foodsAdded.keys), id: \.self) { food in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(food.name)
                            Text(getQuantity(food: food, quantity: foodsAdded[food] ?? 0))
                          
                       
                        }
                        Spacer()
                        Text(calculateCalories(food: food, quantity: foodsAdded[food] ?? 0))
                       
                      
                    }
                    .padding([.bottom, .trailing, .leading, .top], 5)
                    .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.blue, lineWidth: 2)
                        )
                   
                
                .padding()
                
        
            
            
        }
    }
    //
    func calculateCalories(food: Food, quantity: Double) -> String {
        return String(format: "%1.f", food.calories * quantity)
    }
    
    func getQuantity(food: Food, quantity: Double) -> String {
       
        return quantity > 1 ? String(format: "%1.f ", quantity) + food.servingType + "s" : String(format: "%1.f ", quantity) + food.servingType
    }
}

#Preview {
    @Previewable @State var foodsAdded: [Food: Double] = [Food.example: 1.0, Food.another_example: 2.0]
    FoodsAddedView(foodsAdded: $foodsAdded)
}
