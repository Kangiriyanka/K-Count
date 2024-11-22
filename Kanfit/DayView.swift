//
//  DayView.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/10.
//

import SwiftUI



struct DayView: View {
    
    struct CustomButtonStyle : ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding()
                .foregroundColor(.white)
                .background(configuration.isPressed ? Color.blue : Color.red)
                .cornerRadius(10)
            
        }
    }
    
    var day: Day
 
   
    
    // Here I need the person's tdee, thats why its in day view
    let person: Person

    @State private var showingAddScreen = false

    
    
    var body: some View {
      
            
        
        NavigationStack{
                
                List {
                    Section(header: Text("Foods eaten")) {
                      
                        
                        if day.foodsEaten.isEmpty {
                            EmptyFoodRow()
                        }
                         
                            
        
                        ForEach(Array(day.foodsEaten.keys), id: \.self) { food in
                                HStack {
                                    Text(food.name)
                                    Spacer()
                                    Text("\(Int(food.calories))")
                                        .foregroundStyle(.secondary)
                                }
                                
                            }
                        .onDelete(perform: deleteFood)
                        
                       
                    }
                    
                    Section(header: Text("Calculations")) {
                        CalculationsRow(rowName: "Total Calories:", value: String(day.totalCalories))
                        
                       
                        
                        CalculationsRow(rowName: "Remaining Calories:", value: String(person.TDEE - day.totalCalories))
                    }
                   
                    Section(header: Text("Weight")) {
                        HStack {
                            Text(day.weight == 0.0 ? "Enter your weight" :  "\(day.weight, specifier: "%.1f") kg" )
                            
                            
                            NavigationLink(destination: AddWeightView(day: day, person: person)) {
                                
                              
                             
                                
                            }
                         
                           
                        
                          
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
    
    func deleteFood(at offsets: IndexSet) {
           for index in offsets {
               let key = Array(day.foodsEaten.keys)[index]
               day.foodsEaten.removeValue(forKey: key)
           }
       }
    
 
    }
    


#Preview {
    
    DayView( day: .example, person: Person.example)
}
