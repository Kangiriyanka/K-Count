//
//  ViewExtensions.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/17.
//

import Foundation
import SwiftUI

// MARK: - Card Modifiers

struct DataCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, minHeight: 50)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .fontWeight(.semibold)
            .foregroundStyle(.black
            )
            .background(Color.burntOrange.opacity(0.8), in: RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.burntOrange.opacity(0.3)))
            .shadow(color: Color.burntOrange.opacity(0.3), radius: 3)
    }
}

// MARK: - Previews

#Preview("DataCard Styles") {
    VStack(spacing: 20) {
        Text("Data Card Example")
            .dataCardStyle()
        
        Text("Small Data Card Example")
            .smallDataCardStyle()
        
        VStack(alignment: .leading, spacing: 8) {
            Text("Weight: 75.5 kg")
            Text("Height: 180 cm")
            Text("BMI: 23.3")
        }
        .dataCardStyle()
        
        HStack {
            Text("Steps")
            Spacer()
            Text("10,247")
                .fontWeight(.semibold)
        }
        .smallDataCardStyle()
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}

struct SmallDataCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.white, in: RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.06), radius: 2)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(.gray.opacity(0.1)))
    }
}

// MARK: - Custom Shapes

struct LeftBorder: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        return path
    }
}

// MARK: - View Extensions

extension View {
    func endTextEditing() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil, from: nil, for: nil
        )
    }
    
    func borderedBackground(_ color: Color) -> some View {
        listRowBackground(
            ZStack(alignment: .leading) {
                Color.white
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
