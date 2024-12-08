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
                            Text(getServingSize(food: food, servingSize: foodsAdded[food] ?? 0))
                          
                       
                        }
                        Spacer()
                        Text(calculateCalories(food: food, servingSize: foodsAdded[food] ?? 0))
                       
                      
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
    func calculateCalories(food: Food, servingSize: Double) -> String {
        return String(format: "%0.1f", food.calories * servingSize)
    }
    
    func getServingSize(food: Food, servingSize: Double) -> String {
       
        return servingSize > 1 ? String(format: "%0.1f ", servingSize) + food.servingType + "s" : String(format: "%0.f ", servingSize) + food.servingType
    }
}

#Preview {
    @Previewable @State var foodsAdded: [Food: Double] = [Food.example: 1.0, Food.another_example: 2.0]
    FoodsAddedView(foodsAdded: $foodsAdded)
}
