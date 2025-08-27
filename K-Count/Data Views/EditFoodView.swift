//
//  EditFoodView.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2025/07/06.
//

import SwiftUI

struct EditFoodView: View {
    var food: Food
    
    @State private var foodName: String
    @State private var calories: String
    @State private var servingType: String
    
    @FocusState private var firstFoodNameFieldIsFocused: Bool
    var body: some View {
        
        NavigationStack {
            Form {
                Section("Edit \(foodName)") {
                    TextField("Enter food name", text: $foodName)
                        .focused($firstFoodNameFieldIsFocused)
                    TextField("Enter calories ", text: $calories)
                        .keyboardType(.decimalPad)
                        .limitDecimals($calories, decimalLimit: 1, prefix: 4)
                    TextField("Enter serving type", text: $servingType)
                        .autocapitalization(.none)
                    
                    
           
                    
                }
                
            }
            
            .listRowBackground(Color.clear)
            .scrollContentBackground(.hidden) 
            
            .toolbar {
              
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveFood()
                    }
                    .fontWeight(.semibold)
                 
                }
            }
        }
        
    
  
        
    }
    
    
    
    func saveFood() {
        
        food.name = foodName
        food.calories = Double(calories) ?? 0.0
        food.servingType = servingType
        
    }
    
    init(food: Food) {
        self.food = food
        self.foodName = food.name
        self.calories = String(food.calories)
        self.servingType = food.servingType
        
    }
}


#Preview {
    EditFoodView(food: Food.exampleDairy)
}
