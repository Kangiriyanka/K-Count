//
//  AddFood.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/10.
//


// Discussion Points: Usage of tags in the Picker.

import SwiftUI
import SwiftData



enum Modes: String, CaseIterable {
    case search = "Search"
    case addNew = "New Food"
}

struct CustomPicker: View {
    @Binding var selectedMode: Modes
    @Namespace private var namespace

    var body: some View {
        HStack {
            ForEach(Modes.allCases, id: \.self) { mode in
                Button(action: {
                    withAnimation {
                        selectedMode = mode
                    }
                }) {
                    Text(mode.rawValue)
                        .font(.headline)
                        .padding()
                        .background(
                            ZStack {
                                if selectedMode == mode {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.accentColor)
                                        
                                        
                                        .matchedGeometryEffect(id: "background", in: namespace)
                                }
                            }
                        )
                        .foregroundColor(selectedMode == mode ? .white : .black)
                }
                .buttonStyle(.plain)
            }
        }
        .frame(maxWidth: .infinity)
    }
}


struct AddFoodView: View {
    
    @Environment(\.dismiss) var dismiss
    @Query var foods: [Food]
    @Bindable var day: Day
    @State private var foodsAdded: [FoodEntry] = []
    @State private var foodName = ""
    @State private var calories = ""
    @State private var servingType = ""
    @State private var addExistingFood = false
    @State private var searchText: String = ""
    @State private var selectedMode: Modes = .search
    @State private var showingPopover: Bool = false
    @State private var isClicked = false
  
    
    
    
    
 
    
    var filteredFoods: [Food] {
            if searchText.isEmpty {
                return foods
            } else {
                return foods.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
            }
        }
   
   

    var body: some View {
        
        NavigationStack {
            
          
            
            Form {
                
            
                Section("Select a mode") {
                 
                    CustomPicker(selectedMode: $selectedMode)
                        .frame(maxWidth: .infinity, maxHeight: 400)
                        .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
                        
                      
                        .shadow(radius: 2, x: 0, y: 0.5)
        
                    
                    }
                .listRowBackground(Color.clear)
               
                
                 
                
                
                if selectedMode == .addNew {
                    
                  
                    NewFoodView(foodsAdded: $foodsAdded)
                       
                       
                      
                   
                    
                } else if selectedMode == .search {
                    
                    Section("List of Foods") {
                        if foods.isEmpty {
                            
                            ContentUnavailableView {
                                Label("No foods added", systemImage: "basket")
                            } description: {
                                Text("Create a new food by tapping on New Food")
                            }
                            
                        }
                        else {
                        
                            
                            List {
                                ForEach(filteredFoods, id: \.self  ) { food in
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
              
                    
                }
          
        
 
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText,  placement: .navigationBarDrawer(displayMode: .always))
  
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        
                        showingPopover = true
                        isClicked.toggle()
                        
                    } label : {
                        Image(systemName: "basket")
                        
                        
                            .font(.title2)
                        
                    }
                    .symbolEffect(.wiggle, value: isClicked)
                    .overlay(
                        ZStack {
                            Circle()
                                .stroke(Color.emeraldGreen, lineWidth: 1) //
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
                    HStack {
                        Button("Cancel", role: .cancel) {
                            dismiss()
                        }
                        .foregroundColor(.red)
                        
                        Button("Done") {
                            day.foodEntries = foodsAdded
                            dismiss()
                        }
                    }
                }
            }
                
              
            }
          
        }
        
        
    }
    

    
   

  



#Preview {

    AddFoodView(day: Day.example)
   
}
