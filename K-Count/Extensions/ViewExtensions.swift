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
            .font(.body.weight(.medium))
            .foregroundStyle(.white)
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
        self.onChange(of: number.wrappedValue) { _,_ in
            let input = number.wrappedValue
            
            // Remove invalid characters, keep only numbers and one decimal point
            let filtered = input.replacingOccurrences(of: "[^0-9.]", with: "", options: .regularExpression)
            
            // Handle multiple decimal points
            let components = filtered.components(separatedBy: ".")
            var result = components[0]
            
            if components.count > 1 {
                result += "." + components[1]
            }
            
            // Apply length limits
            if result.contains(".") {
                let parts = result.components(separatedBy: ".")
                let integerPart = String(parts[0].prefix(prefix))
                let decimalPart = parts.count > 1 ? String(parts[1].prefix(decimalLimit)) : ""
                result = integerPart + (decimalPart.isEmpty ? "" : "." + decimalPart)
            } else {
                result = String(result.prefix(prefix))
            }
            
            number.wrappedValue = result
        }
    }
}
