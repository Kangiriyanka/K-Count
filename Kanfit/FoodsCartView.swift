//
//  FoodsInCartView.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/22.
//

import SwiftUI

struct FoodsCartView: View {
    @Binding var foodsAdded: [Food: Double]
    
    var body: some View {
        if foodsAdded.isEmpty {
            Text("Click a food to add it").italic()
        }
        VStack {
          
            ForEach(Array(foodsAdded.keys), id: \.self) { food in
                HStack {
                    Text(food.name)
                    Spacer()
                    Text(String(foodsAdded[food] ?? 0.0))
                    Spacer()
                    Text(String(food.calories * (foodsAdded[food] ?? 1.0)))
                }
            }
            .padding()
            
           
            
            
        }
    }
}

#Preview {
    @Previewable @State var foodsAdded: [Food: Double] = [Food.example: 1.0]
    FoodsCartView(foodsAdded: $foodsAdded)
}
