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
    @State private var foodsAdded : [Food: Double] = [:]
    @State private var foodName = ""
    @State private var calories = ""
    @State private var servingType = ""
    @State private var addExistingFood = false
    @State private var searchText: String = ""
    @State private var selectedMode: AddFoodMode = .search
    @State private var showingPopover: Bool = false
    @State private var isClicked = false
    
    
    // Enum to represent picker modes
    enum AddFoodMode: String, CaseIterable {
        case search = "Search"
        case addNew = "New Foods"
    }
   
    @State private var existingFoods: [Food] = FileManager.default.decode("foods.json")
    

    var body: some View {
        
        NavigationStack {
            
          
            
            Form {
                
            
                    Section {
                        Picker("Choose mode", selection: $selectedMode) {
                            ForEach(AddFoodMode.allCases, id: \.self) { mode in
                                Text(mode.rawValue)
                                    .tag(mode)
                            }
                           
                        }
                        .pickerStyle(.segmented)
                        .listRowBackground(EmptyView())
                    }
                
                
                if selectedMode == .addNew {
                                
                    NewFoodView(existingFoods: $existingFoods, foodsAdded: $foodsAdded)
                    
                    } else if selectedMode == .search {
                                Section("Add existing food") {
                                    List {
                                        ForEach(existingFoods, id: \.self  ) { food in
                                            NavigationLink(destination: FoodView(food: food, foodsAdded: $foodsAdded)) {
                                                
                                                VStack(alignment: .leading){
                                                    Text(food.name)
                                                    HStack {
                                                       ( Text(food.calories.formatted() + " cal")
                                                        +
                                                        Text(" / \(food.servingType)")
                                                       ).foregroundStyle(.secondary)
                                                    }
                                                    
                                                    
                                                }
                                            
                                                
                                            }
                                           
                                            
                                        }
                                       
                                    }
                                    
                                
                                }
                            }
                
               
              
                    
                }
            
                
            
        
 
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        
                        showingPopover = true
                        isClicked.toggle()
                        
                    } label : {
                        Image(systemName: "cart")
                            
                            .font(.title2)
                    }
                    .symbolEffect(.wiggle, value: isClicked)
                    .overlay(
                        ZStack {
                            Circle()
                                .stroke(Color.blue, lineWidth: 0.5) //
                                .frame(width: 15, height: 15)
                            Text(String(foodsAdded.count)).bold()
                                
                                .font(.caption)
                                
                        },
                        alignment: .topTrailing
                    )
                   
                    
                    .popover(isPresented: $showingPopover,  content : {
                        
                        // Pass the selectedDate as a Binding
                        FoodsAddedView(foodsAdded: $foodsAdded)
                            
                            .frame(minWidth:300, maxHeight:400)
                            .presentationCompactAdaptation(.popover)
                           
                           
                        
                        
                    })
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        
                        // Current: the value of day.foodseaten for the key that exists in both dictionaries
                        
                        // New: The new value from foodsAdded for the key that exists in both dictionaries
                        day.foodsEaten = day.foodsEaten.merging(foodsAdded) {
                            (current,new) in current + new
                        }
                        dismiss()
                    }
                }
            }
          
        }
        
        
    }
    

    
   

  

}

#Preview {

    AddFoodView(day: Day.example)
   
}
