//
//  EditFoodView.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2025/07/06.
//

import SwiftUI
import SwiftData

struct EditFoodDataView: View {
    var food: Food
    
    @State private var foodName: String
    @State private var calories: String
    @State private var servingType: ServingType
    @State private var isPresentingConfirm: Bool = false
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @FocusState private var firstFoodNameFieldIsFocused: Bool
   
    var body: some View {
        
        NavigationStack {
            Form {
                Section("Edit ") {
                    TextField("Enter food name", text: $foodName)
                        .focused($firstFoodNameFieldIsFocused)
                    TextField("Enter calories ", text: $calories)
                        .keyboardType(.decimalPad)
                        .limitDecimals($calories, decimalLimit: 1, prefix: 4)
                    Picker("Serving type", selection: $servingType) {
                        ForEach(ServingType.allCases, id: \.self) { servingType in
                            Text(servingType.displayName).tag(servingType)
                        }
                    }
                    
                    
                }
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
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Delete", systemImage: "trash", role: .destructive) {
                            isPresentingConfirm = true
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                    .confirmationDialog("Are you sure?", isPresented: $isPresentingConfirm) {
                         Button("Delete this food permanently?", role: .destructive) {
                             deleteFood(food: food)
                         }
                     }
                }
            }
        }
    }
    
    private func saveFood() {
        guard !foodName.isEmpty else { return }
        food.name = foodName
        food.calories = Double(calories) ?? 0.0
        food.servingType = servingType.rawValue
        
        
        
    }
    
    private func deleteFood(food: Food) {
        // Manually delete all entries first
        let entriesToDelete = food.entries
        for entry in entriesToDelete {
            modelContext.delete(entry)
        }
        
        // Save the entry deletions
        try? modelContext.save()
        
        // Now delete the food
        modelContext.delete(food)
        try? modelContext.save()
        
        dismiss()
    }
    
    private func isDisabled() -> Bool {
        if foodName.isEmpty || calories.isEmpty  {
            return true
        }
        return false
    }
    
    init(food: Food) {
       
        self.food = food
        self.foodName = food.name
        self.calories = String(food.calories)
        self.servingType = ServingType(rawValue: food.servingType) ?? .gram
    }
}

#Preview {
    EditFoodDataView(food: Food.exampleDairy)
}
