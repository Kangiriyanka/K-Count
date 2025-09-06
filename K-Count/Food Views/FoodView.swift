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
    @Binding var foodsAdded: [FoodEntry]
    
    var body: some View {
        
        NavigationStack {
            
            
            ZStack {
                
                
                VStack(alignment: .leading) {
                    Text(food.name).font(.title).bold()
                    Text("per " + food.servingType)
                    Divider()
                    
                    HStack {
                        Text("Servings")
                        Spacer()
                           
                        TextField("Servings", text: $servingSize)
                            .keyboardType(.decimalPad)
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
                    
                        
                      
                  
                    
                    Divider()
                      
                    HStack {
                        Spacer()
                        Button {
                           updateFoodEntries()
                           
                            dismiss()
                            
                            
                        } label: {
                            Image(systemName: "plus")
                        }
                       
                        
                      
                        
                      
                        .buttonStyle(AddButton())
                        .padding()
                        
                        
                        Spacer()
                        
                        
                        
                        
                    }
                    
                }
            }
            
        
          
        }
     
        .padding()
        
      
    }
    // If the food is already in the FoodEntries, just update the portions
    // Otherwise create a new FoodEntry
    private func updateFoodEntries() {
        if let existingIndex = foodsAdded.firstIndex(where: {$0.food.name == food.name}) {
            // Replace the entire entry instead of mutating it
            foodsAdded[existingIndex] = FoodEntry(food: food, servingSize: Double(servingSize) ?? 1)
        } else {
            foodsAdded.append(FoodEntry(food: food, servingSize: Double(servingSize) ?? 1))
        }
    }

    init(food: Food, foodsAdded: Binding<[FoodEntry]>) {
        self.food = food
        self._foodsAdded = foodsAdded
        self.totalCalories = food.calories
        
    }
}
                 
                 

