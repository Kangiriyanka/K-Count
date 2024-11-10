//
//  AddFood.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/10.
//


import SwiftUI

struct AddFoodView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Bindable var day: Day
    @State private var foodName = ""
    @State private var calories = ""
    @State private var selectedFood : Food?
    @State private var addExistingFood = false
    @State private var newFoodEnabled = false
   
    let existingFoods: [Food] = FileManager.default.decode("foods.json")
    
    var isValidNewFood: Bool {
        !foodName.isEmpty && Double(calories) != nil
    }

    var canSave: Bool {
        (newFoodEnabled && isValidNewFood) || (!newFoodEnabled && selectedFood != nil)
    }
    
    
    var body: some View {
        
        NavigationStack {
            Form {
                
                Section("Choose what to do") {
                    Toggle("Add new food", isOn: $newFoodEnabled)
                        .onChange(of: newFoodEnabled) {
                            
                                selectedFood = nil
                                foodName = ""
                                calories = ""
                            }
                        }
                
                
                if newFoodEnabled == true {
                    Section("Add a new food") {
                       
                        
                      
                      
                            
                            TextField("Enter food name", text: $foodName)
                            TextField("Enter calories", text: $calories)
                        
                    }
                    
                }
                
                else {
                    
                    Section("Add existing food") {
                        
                        Picker("Choose an existing food", selection: $selectedFood) {
                            
                            Text("None").tag(nil as Food?)
                            ForEach(existingFoods, id: \.self) { food in
                                
                               
                                Text(food.name)
                                    .tag(food as Food)
                                
                                
                                
                                
                                
                            }
                            
                            
                            
                        }
                        .pickerStyle(.navigationLink)
                    }
                   
                  
                }
                
               
               
                Section("Save") {
                    Button("Save") {
                        
                        if newFoodEnabled {
                            let newFood = Food(id: existingFoods.count + 1, name: foodName, calories: Double(calories) ?? 0)
                            day.foodsEaten.append(newFood)
                            writeFood(newFood, existingFoods: existingFoods)
                            dismiss()
                        }
                        
                        else {
                            
                            day.foodsEaten.append(selectedFood!)
                            dismiss()
                        }
                       
                       
                        
                    }
                 
                } .disabled(canSave == false)
                    
                }
            
                
            
           
            .navigationTitle("Add food")
        }
        
        
    }
    
    func writeFood(_ food: Food, existingFoods: [Food]) {
        let url = URL.documentsDirectory.appendingPathComponent("foods.json")
        // Step 1: Copy existing foods and append the new food
        var updatedFoods = existingFoods
        updatedFoods.append(food)
        
        // Step 2: Encode and write the updated array back to file
        do {
            let updatedData = try JSONEncoder().encode(updatedFoods)
            try updatedData.write(to: url, options: [.completeFileProtection])
            print("\(food.name) saved successfully")
        } catch {
            print("Error writing to file: \(error)")
        }
    }
  

}

#Preview {

    AddFoodView(day: Day.example)
   
}
