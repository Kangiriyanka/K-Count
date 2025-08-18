//
//  ShowFoodListButton.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/12/09.
//

import SwiftUI


struct ShowFoodListButton : ButtonStyle {
     func makeBody(configuration: Configuration) -> some View {
         configuration.label
             
         .bold()
         .font(.title3)
         .clipShape(Capsule())
         .foregroundStyle(Color.white)
         .padding(5)
         .background(Color.accentColor)
        
         
         
 
    
     }
         
     }

 

#Preview {
    Button("Test") {
       
    }
    .buttonStyle(ShowFoodListButton())
    
}



