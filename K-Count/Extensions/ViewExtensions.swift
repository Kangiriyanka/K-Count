//
//  ViewExtensions.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/17.
//

import Foundation
import SwiftUI


extension DateFormatter {
    static let dayOfWeek: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }()
}

// MARK: - Card Modifiers

struct DataCard: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        let isDark = colorScheme == .dark
        
        content
            .frame(maxWidth: .infinity, minHeight: 50)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .fontWeight(.semibold)
            .foregroundStyle(isDark ? .white.opacity(0.8) : .black)
            .background(
                (isDark ? Color.burntOrange.opacity(0.8) : Color.burntOrange.opacity(0.85)),
                in: RoundedRectangle(cornerRadius: 12)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.burntOrange.opacity(isDark ? 0.5 : 0.3))
            )
           
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
    let normalPadding: CGFloat = 12

    func body(content: Content) -> some View {
        content
            .padding(.horizontal, normalPadding)
            .padding(.vertical, normalPadding)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.secondarySystemGroupedBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.separator), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
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
    
    func borderedBackground(_ color: Color, _ backgroundColor: Color) -> some View {
        
        listRowBackground(
            ZStack(alignment: .leading) {
                backgroundColor
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
    
    func limitText(_ text: Binding<String>, to limit: Int) -> some View {
           self.onChange(of: text.wrappedValue) { _, newValue in
               if newValue.count > limit {
                   text.wrappedValue = String(newValue.prefix(limit))
               }
           }
       }
    
    /// Restricts user input in a bound `TextField` to numeric values with limited digits.
    /// - Parameters:
    ///   - number: The bound `String` value from a `TextField`.
    ///   - decimalLimit: The maximum number of digits allowed after the decimal point.
    ///   - prefix: The maximum number of digits allowed before the decimal point.
    /// - Returns: A modified `View` that enforces these input restrictions.
    ///
    /// This modifier:
    /// 1. Prevents multiple decimals (`..` becomes `.`).
    /// 2. Strips leading zeros and dots to avoid invalid numbers.
    /// 3. Removes all non-numeric characters except the decimal point.
    /// 4. Enforces maximum digits before and after the decimal point.
    func limitDecimals(_ number: Binding<String>, decimalLimit: Int, prefix: Int) -> some View {
        self
            .onChange(of: number.wrappedValue) {
                
                
                let cleanedInput = number.wrappedValue
                    .replacingOccurrences(of:  "\\.{2,}", with: ".", options: .regularExpression)
                    .replacingOccurrences(of: "^(0)(?!\\.)", with: "", options: .regularExpression)
                    .replacingOccurrences(of: "[^0-9.]", with: "", options: .regularExpression)
                
                number.wrappedValue = cleanedInput
                let components = cleanedInput.components(separatedBy: ".")
               
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
