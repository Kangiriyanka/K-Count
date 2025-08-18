//
//  NewFoodView.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/26.
//

import SwiftUI
import SwiftData

struct NewFoodView: View {
    
    @Query var foods: [Food]
    @State private var foodName: String = ""
    @State private  var calories: String =  ""
    @State private var  servingType: String = ""
    @State private var servingSize: String = ""
    @State private var duplicateFoodPresented = false
    @FocusState private var firstFoodNameFieldIsFocused: Bool
    @Binding var foodsAdded: [FoodEntry]
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    
    var body: some View {
        Section("Add a new food") {
            TextField("Enter food name", text: $foodName)
                .focused($firstFoodNameFieldIsFocused)
            TextField("Enter calories " , text: $calories)
                .keyboardType(.decimalPad)
                .limitDecimals($calories, decimalLimit: 1, prefix: 4)
            TextField("Enter serving type", text: $servingType)
                .autocapitalization(.none)
            TextField("Enter number of servings", text: $servingSize)
                .keyboardType(.decimalPad)
                .limitDecimals($servingSize, decimalLimit: 1, prefix: 4 )
            
            
            Button {
                
                saveFood()
                resetFields()
                
                
            } label: {
                Image(systemName: "plus")
            }
            
            .buttonStyle(AddButton())
            .frame(maxWidth: .infinity)
            .listRowBackground(EmptyView())
            // Disable the add button if one of the fields isn't filled.
            .disabled(!areFieldsFilled())
            .alert("Food already exists", isPresented: $duplicateFoodPresented) { }
            
            
        }
        
        
        
    }
    
    func saveFood() {
        
        let newFood = Food(name: foodName, calories: Double(calories) ?? 0, servingType: servingType)
        if foods.contains(where: { $0.name == newFood.name }) {
            duplicateFoodPresented = true
            return
            
        }
        
        modelContext.insert(newFood)
        foodsAdded.append(FoodEntry(food: newFood, servingSize: Double(servingSize) ?? 0))
       
    }
    
    func areFieldsFilled() -> Bool {
        
        return !foodName.isEmpty && !calories.isEmpty && !servingType.isEmpty && !servingSize.isEmpty
    }
    
    func resetFields() {
        foodName = ""
        calories = ""
        servingType = ""
        servingSize = ""
        firstFoodNameFieldIsFocused = true
        
    }
    
    
}
