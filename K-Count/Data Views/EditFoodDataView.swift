//
//  EditFoodView.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2025/07/06.
//

import SwiftUI

struct EditFoodDataView: View {
    var food: Food
    
    @State private var foodName: String
    @State private var calories: String
    @State private var servingType: String
    @State private var isPresentingConfirm: Bool = false
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @FocusState private var firstFoodNameFieldIsFocused: Bool
   
    var body: some View {
        
        NavigationStack {
            Form {
                Section("Edit \(food.name)") {
                    TextField("Enter food name", text: $foodName)
                        .focused($firstFoodNameFieldIsFocused)
                    TextField("Enter calories ", text: $calories)
                        .keyboardType(.decimalPad)
                        .limitDecimals($calories, decimalLimit: 1, prefix: 4)
                    TextField("Enter serving type", text: $servingType)
                        .autocapitalization(.none)
                    
                    
                    
                 
                    
                    
           
                    
                }
           
                VStack(alignment: .center) {
                    Button("Delete", role: .destructive) {
                        isPresentingConfirm = true
                        
                    }
                 
                    .confirmationDialog("Are you sure?",
                                        isPresented: $isPresentingConfirm) {
                        Button("Delete this food permanently?", role: .destructive) {
                            deleteFood(food: food )
                        }
                    }
                                        .disabled(isDisabled())
                                        .fontWeight(.semibold)
                }
                
                .buttonStyle(BorderedProminentButtonStyle())
                
                .frame(maxWidth: .infinity)
                
            }
            
            .listRowBackground(Color.clear)
            .scrollContentBackground(.hidden) 
            
            .toolbar {
              
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveFood()
                        dismiss()
                    }
                    .disabled(isDisabled())
                    .fontWeight(.semibold)
                 
                }
                
               
            }
        }
        
    
  
        
    }
    
    
    
    private func saveFood() {
        
        food.name = foodName
        food.calories = Double(calories) ?? 0.0
        food.servingType = servingType
        
    }
    
    private func deleteFood(food: Food) {
        do {
            try modelContext.delete(food)
            try modelContext.save() // Don't forget to save changes
        } catch {
            print("Failed to delete food: \(error.localizedDescription)")
           
        }
    }
    
    private func isDisabled() -> Bool {
        if foodName.isEmpty || calories.isEmpty || servingType.isEmpty {
            return true
        }
        return false
    }
    
    init(food: Food) {
        self.food = food
        self.foodName = food.name
        self.calories = String(food.calories)
        self.servingType = food.servingType
        
    }
}


#Preview {
    EditFoodDataView(food: Food.exampleDairy)
}
