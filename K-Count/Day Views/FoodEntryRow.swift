

// A row containing the food name, the serving size under it and the calories on the extreme right.
// Serving sizes are represented with 1 decimal and calories with whole numbers
// Adds plural to serving type if the serving size is bigger than a unit.
// The FoodRow is itself a NavigationLink that leads to the EditPortionsView

import SwiftUI
struct FoodEntryRow: View {
    let foodEntry: FoodEntry
    
    var servingTypePlural: String {
        let servingType = ServingType(rawValue: foodEntry.food.servingType) ?? .gram
        
        return foodEntry.servingSize > 1.0 ?
        servingType.pluralForm
        :
        servingType.rawValue
    }
    var body: some View {
        
      
        
        
        
        HStack {
            
            HStack {
                
                let stringQuantity =  String(format: "%0.1f", foodEntry.servingSize)
                let totalCalories = String(format: "%0.0f", foodEntry.servingSize * foodEntry.food.calories)
                
                
                VStack(alignment: .leading) {
                    
                    
                    Text(foodEntry.food.name).bold()
                  
                    Text("\(stringQuantity) \(servingTypePlural)")
                        .foregroundStyle(.secondary)
                  
                    
                }
                
                
                Spacer()
                
                Text(totalCalories)
                    .foregroundStyle(.secondary)
            }
            
        }
        
        
        
        
        .overlay(
            
            NavigationLink(destination: EditPortionsView(foodEntry: foodEntry)) {}
                .opacity(0)
        )
    }
    
    
    
    
}
#Preview {
    let example = FoodEntry.example
    FoodEntryRow(foodEntry: example)
   
}
