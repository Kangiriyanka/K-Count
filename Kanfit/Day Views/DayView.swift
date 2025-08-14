//
//  DayView.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/10.
//

import SwiftUI
import SwiftData

struct DayView: View {
    
    @AppStorage("userSettings") var userSettings = UserSettings()
    @Environment(\.modelContext) private var modelContext
    @State private var showingAddFoodSheet = false
    @State private var isVisible = 0
    @State private var angle = 30.0
    
    var day: Day
    var body: some View {
        
        NavigationStack {
            
            List {
                
            // A VStack containing information about the weight, calories consumed and remaining calories.
                Section(header: Text("Day Info")) {
                    DayInfoView(
                        day: day,
                        totalCalories: String(format: "%0.f", day.totalCalories),
                        remainingCalories: String(format: "%0.f", userSettings.calculateTDEE(using: day.weight) - day.totalCalories)
                    )
                    .borderedBackground( Color.burntOrange)

                }
     
            // List of all the foods eaten of that day
                Section(header: Text("Foods Eaten")) {
                   
                    
                    if day.foodEntries.isEmpty {
                        Text("No foods added yet").foregroundStyle(.secondary)
                            .listRowSeparator(.hidden)

                        
                       
                    } 
                    
                    ForEach(day.foodEntries, id: \.self) { entry in
                        
                        
                        FoodEntryRow(foodEntry: entry)
                            .borderedBackground( Color.accentColor)
                           
                         
                            .listRowSeparator(.hidden)
                         
                    

                    }
                   
        
                    .onDelete(perform: deleteFood)
   
                }
            }
            
            
          
            
            .listRowSpacing(10)
            .navigationTitle(day.formattedDate)
            .navigationBarTitleDisplayMode(.inline)
          
            .toolbar {
                ToolbarItem {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: {
                        showingAddFoodSheet = true
                    }) {
                      
                            // Base Button Content
                            
                            Image(systemName: "fork.knife")
                            
                    
                   
                        
                    }
                }
              
            }
            .sheet(isPresented: $showingAddFoodSheet) {
                AddFoodView(day: day)
            }
            
        }
    }
    
    // IndexSets can store either ranges or just indices
    // Convert the keys into an Array and get the key matching the index
    // Removes the Key Value pair
    func deleteFood(at offsets: IndexSet) {
       
        withAnimation {
          
            for index in offsets {
                let entry = day.foodEntries[index]
                modelContext.delete(entry)
            }
                    
                day.foodEntries.remove(atOffsets: offsets)
                
            }
        }
        
        
    }
    



#Preview {
    
 
    DayView(day: Day.example)
       
      
}
