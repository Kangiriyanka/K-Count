//
//  ViewExtensions.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/17.
//

import Foundation
import SwiftUI


extension View {
    //    Binding allows you to use a variable in a view somewhere else
    //    onChange is triggered every time you enter a digit in the TextField
    func limitDecimals(_ number: Binding<String>, decimalLimit: Int) -> some View {
        self
            .onChange(of: number.wrappedValue) {
                
             
                let cleanedInput = number.wrappedValue
                    .replacingOccurrences(of:  "\\.{2,}", with: ".", options: .regularExpression)
                    .replacingOccurrences(of: "^0|^\\.", with: "", options: .regularExpression)
                    .replacingOccurrences(of: "[^0-9.]", with: "", options: .regularExpression)
                
                number.wrappedValue = cleanedInput
                let components = cleanedInput.components(separatedBy: ".")
                print(components)
                // No decimal
                if components.count == 1 {
                    number.wrappedValue = String(number.wrappedValue.prefix(3))
                }
                
                else  {
                    
                    let integerPart = components[0]
                    let totalLimit = integerPart.count + decimalLimit + 1
                    number.wrappedValue = String(number.wrappedValue.prefix(totalLimit))
                }
            }
    }
    
    func endTextEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
      }
    }

                    
                    
               
 
    
    
    


