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
            .frame(width: 75, height: 25)
            .padding()
            .background(Color.accentColor)
            .foregroundColor(.white).bold()
            .clipShape(Capsule(style: .continuous))
           
        

            }
    }


struct OnboardingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 200, height: 25)
            .padding()
            .background(Color.accentColor)
            .foregroundColor(.white).bold()
            .clipShape(Capsule(style: .continuous))
           
        

            }
    }
                       
        
    

