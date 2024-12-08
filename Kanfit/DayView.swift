//
//  DayView.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/10.
//

import SwiftUI



struct DayView: View {
    
    
    @State private var showingAddScreen = false
    
    
    var day: Day
    var person: Person

    
    

    var body: some View {
        
        
        
        NavigationStack{
            
            List {
                Section(header: Text("Foods eaten")) {
                    
                    
                    if day.foodsEaten.isEmpty {
                        EmptyFoodRow()
                    }
                    
                    
                    
                    ForEach(Array(day.foodsEaten.keys), id: \.self) { food in
                        
                       
                            FoodRow(food: food, day: day)
         
                    }
                    .onDelete(perform: deleteFood)
                    
                    
                }
            
                
                Section(header: Text("Weight")) {
                    
                    
                    HStack {
                        Text(day.weight == 0.0 ? "Enter your weight" :  "\(day.weight, specifier: "%.1f") kg" )
                        
                        NavigationLink(destination: EditWeightView(day: day, person: person)) {
                            
                            
                            
                            
                        }
                        
                        
                        
                        
                    }
                    
                    
                    
                }
                
                
                Section(header: Text("Calculations")) {
                    CalculationsRow(rowName: "Total Calories:", value: String(format: "%0.f", day.totalCalories))
                    
                    
                    if day.weight == 0.0 {
                        CalculationsRow(rowName: "Remaining Calories:", value: "0")
                    }
                    else {
                    CalculationsRow(rowName: "Remaining Calories:", value: String(format: "%0.f", person.calculateTDEE(using: day.weight) - day.totalCalories))
                }
                }
                
                
                
                
                
            }
            
            
            .navigationTitle(day.formattedDate)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Food", systemImage: "fork.knife") {
                        showingAddScreen = true
                    }
                }
                
                
                ToolbarItem {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingAddScreen) {
                AddFoodView(day: day)
            }
        }
    }
    
    func getWeight() -> Double {
        return day.weight
    }
    func deleteFood(at offsets: IndexSet) {
        for index in offsets {
            let key = Array(day.foodsEaten.keys)[index]
            day.foodsEaten.removeValue(forKey: key)
        }
    }
    
    
}


