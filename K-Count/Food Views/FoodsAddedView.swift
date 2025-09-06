//
//  FoodsInCartView.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/22.
//

import SwiftUI

struct FoodsAddedView: View {
    @Binding var foodsAdded: [FoodEntry]
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 10) {
                if foodsAdded.isEmpty {
                    Text("No foods added yet!")
                        .font(.subheadline)
                        .italic()
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 40)
                } else {
                    ForEach($foodsAdded, id: \.self) { $entry in
                        let food = entry.food
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(food.name)
                                    .font(.headline)
                                Text(getServingSize(entry: entry))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                            
                            Text("\(Int(food.calories * entry.servingSize)) kcal")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.primary)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.accent.opacity(0.05))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.accent, lineWidth: 0.5)
                        )
                        
                    }
                }
            }
            .padding()
        }
    }
    
    func getServingSize(entry: FoodEntry) -> String {
        let food = entry.food
        let servingType = ServingType(rawValue: food.servingType) ?? .gram
        return entry.servingSize > 1 ?
            String(format: "%0.1f ", entry.servingSize) + servingType.pluralForm :
            String(format: "%0.1f ", entry.servingSize) + servingType.rawValue
    }
}

#Preview {
    @Previewable @State var foods: [FoodEntry] = [
        FoodEntry(food: Food(name: "Banana", calories: 105, servingType: "piece"), servingSize: 1),
        FoodEntry(food: Food(name: "Rice", calories: 200, servingType: "cup"), servingSize: 1.5),
        FoodEntry(food: Food(name: "Chicken Breast", calories: 165, servingType: "gram"), servingSize: 200)
    ]
    
    return FoodsAddedView(foodsAdded: $foods)
}
