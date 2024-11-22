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
   
    let existingFoods: [Food] = FileManager.default.decode("foods.json")
    
    var isValidNewFood: Bool {
        !foodName.isEmpty && Double(calories) != nil
    }


    
    
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
                                Section("Add a new food") {
                                    TextField("Enter food name", text: $foodName)
                                    TextField("Enter calories", text: $calories)
                                        .keyboardType(.decimalPad)
                                }
                            } else if selectedMode == .search {
                                Section("Add existing food") {
                                    List {
                                        ForEach(existingFoods) { food in
                                            NavigationLink(destination: FoodView(food: food, foodsAdded: $foodsAdded)) {
                                                
                                                VStack(alignment: .leading){
                                                    Text(food.name)
                                                    Text(food.calories.formatted() + " cal").foregroundStyle(.secondary)
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
                        FoodsCartView(foodsAdded: $foodsAdded)
                            
                            .frame(minWidth:300, maxHeight:400)
                            .presentationCompactAdaptation(.popover)
                           
                           
                        
                        
                    })
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        
                        
                        day.foodsEaten = foodsAdded
                        dismiss()
                    }
                }
            }
          
        }
        
        
    }
    
    func writeFood(_ food: Food, existingFoods: [Food]) {
        let url = URL.documentsDirectory.appendingPathComponent("foods.json")
        // Step 1: Copy existing foods and append the new food
        var updatedFoods = existingFoods
        updatedFoods.append(food)
        
        // Step 2: Encode and write the updated array back to file
        do {
            let updatedData = try JSONEncoder().encode(updatedFoods)
            try updatedData.write(to: url, options: [.completeFileProtection])
            print("\(food.name) saved successfully")
        } catch {
            print("Error writing to file: \(error)")
        }
    }
    
   

  

}

#Preview {

    AddFoodView(day: Day.example)
   
}
