//
//  EditFoodView.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/12/04.
//

import SwiftUI

struct EditFoodView: View {
    
    @State private var servingSize: Double
    @State private var rawServingSize: String = ""
    @State private var totalCalories: Double
    @FocusState private var isServingSizeFocused: Bool
    @Environment(\.dismiss) private var dismiss
    let food: Food
    var day: Day
    var body: some View {
        NavigationStack {
            
            VStack(alignment: .leading) {
                Text(food.name).font(.title).bold()
                Text("per " + food.servingType.lowercased())
                Divider()
                
                HStack {
                    Text("Servings")
                    Spacer()
                    TextField("Servings", text: $rawServingSize)
                       
                        .keyboardType(.decimalPad)
                        .limitDecimals($rawServingSize, decimalLimit: 1, prefix: 4)
                        .onChange(of: rawServingSize) {
                            calculateCalories()
                        }
                    
                        .focused($isServingSizeFocused).onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                isServingSizeFocused = true
                            }
                        }
                        
                    
                    Text("\(totalCalories, specifier: "%.0f") cals")
                    
                }.multilineTextAlignment(.center)
                    .padding()
                
                
                HStack {
                Spacer()
                Button("Edit", systemImage: "pencil") {
                    
                    day.foodsEaten[food] = servingSize
                    dismiss()
                    
                    
                }
                .buttonStyle(AddButton())
                    Spacer()
                
                
            }
                
            }
            
            
            
            
            
        }
        .padding()
        .navigationTitle("Edit \(food.name)")
        .navigationBarTitleDisplayMode(.inline)
        
    }
    
    
    
    
    
    
    
    func calculateCalories() {
        if let servingSize = Double(rawServingSize) {
            totalCalories = servingSize * food.calories
            self.servingSize = servingSize
        }
        
        
        
    }
    
    init(day: Day, food: Food) {
        self.day = day
        self.food = food
        if let servingSize = day.foodsEaten[food] {
            self.servingSize = servingSize
            self.totalCalories = servingSize * food.calories
            _rawServingSize = State(initialValue: String(servingSize))
            
        }
        else {
            self.servingSize = 0
            self.totalCalories = 0
            
        }
     
        
        
      
 
      
        
        
    }
    
}
    
      

#Preview {
    
    EditFoodView(day: Day.example, food: Food.example)
  
  
}
