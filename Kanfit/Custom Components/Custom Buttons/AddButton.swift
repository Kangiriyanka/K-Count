//
//  AddButton.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/27.
//


import SwiftUI

struct AddButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.accentColor)
            .foregroundColor(.white)
            
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
           
        
    }
}
