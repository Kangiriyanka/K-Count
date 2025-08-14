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
        
        if foodsAdded.isEmpty {
            Text("Nothing added yet.")
                
                .bold()
                .italic()
                
               
                
        }
       
    
            
                
        ForEach($foodsAdded, id: \.self) { $entry in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(entry.food.name)
                            Text(getServingSize(entry: entry))
                                .foregroundStyle(.secondary)
                            Divider()
                          
                       
                        }
                        Spacer()
                        
                        Text(String(entry.food.calories * entry.servingSize))
                       
                      
                    }
                    .padding([.bottom, .trailing, .leading, .top], 5)
                  
                   
                
                .padding()
                
        
            
            
        }
    }
  
    
    func getServingSize(entry: FoodEntry) -> String  {
       
        return entry.servingSize > 1
        ? String(format: "%0.1f ", entry.servingSize) + entry.food.servingType + "s"
        : String(format: "%0.f ", entry.servingSize) + entry.food.servingType
    }
}

