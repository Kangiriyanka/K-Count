//
//  NewFoodView.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/26.
//

import SwiftUI

struct NewFoodView: View {
    
    @State private var foodName: String = ""
    @State private  var calories: String =  ""
    @State private var  servingType: String = ""
    @State private var servingSize: String = ""
    @State private var duplicateFoodPresented = false
    @Binding var existingFoods: [Food]
    @Binding var foodsAdded: [Food: Double]
    @Environment(\.dismiss) private var dismiss
    
    
    var body: some View {
        Section("Add a new food") {
            TextField("Enter food name", text: $foodName)
            TextField("Enter calories " , text: $calories)
                .keyboardType(.decimalPad)
            TextField("Enter serving type", text: $servingType)
                .autocapitalization(.none)
            TextField("Enter number of servings", text: $servingSize)
                .keyboardType(.decimalPad)
            
            Button("Add", systemImage: "plus") {
                
                let newFood = Food(name: foodName, calories: Double(calories) ?? 0, servingType: servingType)
                writeFood(newFood, existingFoods: existingFoods)
            }
            .buttonStyle(AddButton())
            // Disable the add button if one of the fields isn't filled.
            .disabled(!areFieldsFilled())
            .alert("Food already exists", isPresented: $duplicateFoodPresented) { }
           
            
        }
        
        
        
    }
    
    
    func areFieldsFilled() -> Bool {
        
        return !foodName.isEmpty && !calories.isEmpty && !servingType.isEmpty
    }
    
    func writeFood(_ food: Food, existingFoods: [Food]) {
        let url = URL.documentsDirectory.appendingPathComponent("foods.json")
        // Step 1: Copy existing foods and append the new food
        var updatedFoods = existingFoods
        
        // Step 2: Check if the food already exists
        if updatedFoods.contains(where: { $0.name.lowercased() == food.name.trim() }) {
            duplicateFoodPresented = true
            return
        }
        
        // Step 3: Encode and write the updated array back to file
        else {
            updatedFoods.append(food)
            
            do {
                let updatedData = try JSONEncoder().encode(updatedFoods)
                try updatedData.write(to: url, options: [.completeFileProtection])
                print("\(food.name) saved successfully")
            } catch {
                print("Error writing to file: \(error)")
            }
            
            foodsAdded[food] = Double(servingSize)
            self.existingFoods = updatedFoods
           
            
            
        }
    }
}


#Preview {
    @Previewable @State var foodsAdded : [Food: Double] = [:]
    @Previewable @State var existingFoods: [Food] = [Food.example]

    NewFoodView(existingFoods: $existingFoods, foodsAdded: $foodsAdded)
}
