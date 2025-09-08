//
//  ContentViewExtension.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2025/01/03.
//

import Foundation
import SwiftUI


extension ContentView {
    
        func CustomTabItem(imageName: String, title: String, isActive: Bool) -> some View {
            HStack(spacing: 5){
                Spacer()
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(isActive ? Color.customGreen : .gray.opacity(0.9))
                    
                    .offset(y: isActive ? -2 : 0)
                    .animation(isActive ? .spring(response: 0.2, dampingFraction: 0.5, blendDuration: 0.9) : .spring(), value: isActive)
                    .frame(width: 23, height: 28)
                    
                    
              
                Spacer()
            }
           
            
            .cornerRadius(10)
        }
    }

