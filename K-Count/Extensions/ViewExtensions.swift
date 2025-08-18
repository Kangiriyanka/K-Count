//
//  ViewExtensions.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/17.
//

import Foundation
import SwiftUI


struct DataCard : ViewModifier {
    let gradient = Gradient(stops:  [
        Gradient.Stop(color: Color.burntOrange.opacity(0.8), location: 0.1),
        
        Gradient.Stop(color: Color.burntOrange.opacity(0.7), location: 0.6),
  
    ])
    func body(content: Content) -> some View {
        content
            .frame(width: 300, height: 90)
            
            .foregroundStyle(Color.black).bold()
            .font(.title3)
            .contentShape(Rectangle())

            .background(LinearGradient(gradient: gradient, startPoint: .top, endPoint: .bottom))
            .clipShape(RoundedRectangle(cornerRadius: 20))
           
         
            
        
    }
}

struct SmallDataCard : ViewModifier {
    
    func body(content: Content) -> some View {
        content
            
            .padding()
            .foregroundStyle(Color.black).bold()
            .background(Color.white)
            
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 2, x: 0, y: 1)
            

        
    }
}

struct LeftBorder: Shape {
  

    func path(in rect: CGRect) -> Path {
        var path = Path()

        // Calculate the starting and ending points for the line
        let startY = rect.minY
        let endY = rect.maxY

        path.move(to: CGPoint(x: rect.minX, y: startY))
        path.addLine(to: CGPoint(x: rect.minX, y: endY))

        return path
    }
}
    

extension View {
    

  
    func endTextEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
      }
    
    func borderedBackground(_ color: Color) -> some View {
            
           self.listRowBackground(
               ZStack(alignment: .leading) {
                   Color.white // Main background color
                   LeftBorder()
                       .stroke(color, lineWidth: 15)
                     
                   
               }
              
           
           )
        
       
        
       }

 
    func dataCardStyle() -> some View {
        modifier(DataCard())
    }
  
    func smallDataCardStyle() -> some View {
        modifier(SmallDataCard())
    }
    
    
    //    Binding allows you to use a variable in a view somewhere else
    //    onChange is triggered every time you enter a digit in the TextField
    func limitDecimals(_ number: Binding<String>, decimalLimit: Int, prefix: Int) -> some View {
        self
            .onChange(of: number.wrappedValue) {
                
                
                let cleanedInput = number.wrappedValue
                    .replacingOccurrences(of:  "\\.{2,}", with: ".", options: .regularExpression)
                    .replacingOccurrences(of: "^0|^\\.", with: "", options: .regularExpression)
                    .replacingOccurrences(of: "[^0-9.]", with: "", options: .regularExpression)
                
                number.wrappedValue = cleanedInput
                let components = cleanedInput.components(separatedBy: ".")
                // No decimal
                if components.count == 1 {
                    number.wrappedValue = String(number.wrappedValue.prefix(prefix))
                }
                
                else  {
                    
                    let integerPart = components[0]
                    let totalLimit = integerPart.count + decimalLimit + 1
                    number.wrappedValue = String(number.wrappedValue.prefix(totalLimit))
                }
            }
    }
    
    
    
}
    
    
 

                    
                    
               
 
    
    
    


