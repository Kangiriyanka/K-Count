//
//  CustomButtonStyle.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/12/04.
//

import SwiftUI

   struct CustomButtonStyle : ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding()
                .foregroundColor(.white)
                .background(configuration.isPressed ? Color.blue : Color.red)
                .cornerRadius(10)
            
        }
    }
