import SwiftUI
import SwiftData

struct NewFoodView: View {
    
    @Query var foods: [Food]
    @State private var foodName: String = ""
    @State private var calories: String = ""
    @State private var selectedServingType: ServingType = .gram
    @State private var servingSize: String = ""
    @State private var duplicateFoodPresented = false
   
    @Binding var foodsAdded: [FoodEntry]
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    
    
    var body: some View {
        Form {
            Section("Add a new food") {
                TextField("Enter food name", text: $foodName)
          
                
                TextField("Calories per serving", text: $calories)
                    .keyboardType(.decimalPad)
                    .limitDecimals($calories, decimalLimit: 1, prefix: 4)
                
                Picker("Serving type", selection: $selectedServingType) {
                    ForEach(ServingType.allCases, id: \.self) { servingType in
                        Text(servingType.displayName).tag(servingType)
                    }
                }
                .pickerStyle(.menu)
                
                TextField("Serving size", text: $servingSize)
                    .keyboardType(.decimalPad)
                    .limitDecimals($servingSize, decimalLimit: 2, prefix: 4)
                
                Button(action: {
                    saveFood()
                    resetFields()
                }) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Create Food")
                    }
                }
                .buttonStyle(AddButton(width: 150))
                .frame(maxWidth: .infinity)
                .listRowBackground(EmptyView())
                .disabled(!areFieldsValid())
                .alert("This food already exists", isPresented: $duplicateFoodPresented) {
                    Button("OK") { }
                }
            }
        }
        .listRowBackground(Color.clear)
        .scrollContentBackground(.hidden)
      
    }
    
    private func saveFood() {
        guard areFieldsValid() else { return }
        
        let trimmedName = foodName.trimmingCharacters(in: .whitespacesAndNewlines)
        let newFood = Food(
            name: trimmedName,
            calories: Double(calories) ?? 0,
            servingType: selectedServingType.rawValue
        )
        
        if foods.contains(where: { $0.name.lowercased() == newFood.name.lowercased() }) {
            duplicateFoodPresented = true
            return
        }
        
        modelContext.insert(newFood)
        foodsAdded.append(FoodEntry(food: newFood, servingSize: Double(servingSize) ?? 0))
        
      
    }
    
    private func areFieldsValid() -> Bool {
        let trimmedName = foodName.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmedName.isEmpty &&
               !calories.isEmpty &&
               Double(calories) != nil &&
               !servingSize.isEmpty &&
               Double(servingSize) != nil &&
               Double(servingSize)! > 0
    }
    
    private func resetFields() {
        foodName = ""
        calories = ""
        servingSize = ""
        selectedServingType = .gram
      
    }
}

#Preview {
    NavigationStack {
        NewFoodView(foodsAdded: .constant([]))
    }
    .modelContainer(Food.previewContainer())
}
