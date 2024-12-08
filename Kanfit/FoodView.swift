//
//  FoodView.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/21.
//

import Foundation
import SwiftUI


struct FoodView: View {
    
    let food: Food
    @State private var servingSize: String = "1.0"
    @State private var totalCalories: Double
    @FocusState private var isServingSizeFocused: Bool
    @Environment(\.dismiss) private var dismiss
    @Binding var foodsAdded: [Food: Double]
    
    
    var body: some View {
        
        NavigationStack {
            
            VStack(alignment: .leading) {
                Text(food.name).font(.title).bold()
                Text("per " + food.servingType)
                Divider()
                
                HStack {
                    Text("Servings")
                    Spacer()
                    TextField("Servings", text: $servingSize)
                        .keyboardType(.numberPad)
                        .limitDecimals($servingSize, decimalLimit: 1, prefix: 4)
                        .onChange(of: servingSize) {
                            
                            totalCalories = (Double(servingSize) ?? 1) * food.calories
                            
                        }
                        .focused($isServingSizeFocused).onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                isServingSizeFocused = true
                            }
                        }
                    Text("\(totalCalories, specifier: "%.0f") cals")
                    
                } .multilineTextAlignment(.center)
                    .padding()
                
                
                HStack {
                    Spacer()
                    Button("Add", systemImage: "plus") {
                        
                        foodsAdded[food] = Double(servingSize)
                        print(foodsAdded)
                        dismiss()
                        
                        
                    }
                    
                    
                    .buttonStyle(AddButton())
                    
                    Spacer()
                    
                    
                    
                 
                }
               
            }
            
        
          
        }
        .padding()
   
        

    
    

      
    }
    
    init(food: Food, foodsAdded: Binding<[Food: Double]>) {
        
        self.food = food
        self._foodsAdded = foodsAdded
        self.totalCalories = food.calories
        
      
       
        
    }
}
                 
                 

#Preview {
    @Previewable @State var foodsAdded : [Food: Double] = [:]
    let food = Food.example
    FoodView(food: food, foodsAdded: $foodsAdded)
  
}
