//
//  CustomWeightPicker.swift
//  K-Count
//
//  Created by Kangiriyanka The Single Leaf on 2025/08/19.
//

import SwiftUI

struct CustomHeightPicker: View {
    
    
    
    @Binding var preference: MeasurementSystem
    @Binding var height: HeightValue
    @Environment(\.dismiss) private var dismiss
    
    
    var body: some View {
        
        HStack {
            Button(""){}
            Spacer()
            Text("Your Height").fontWeight(.bold)
            Spacer()
            Button("", systemImage: "checkmark.circle") {
                dismiss()
              
                
            }
        }
        .padding()
   
        Divider()
        Picker("System", selection: $preference) {
            ForEach(MeasurementSystem.allCases, id: \.self) { system in
                Text(system.rawValue).tag(system)
            }
        }
        .pickerStyle(.segmented)
        .padding()
        if preference == .metric {
            
            MetricRulerPicker(selectedValue: $height)
            
        }
        
        else {
            
            ImperialRulerPicker(selectedValue: $height)
            
        }
        
    }
}

#Preview {
    CustomHeightPicker(preference: .constant(MeasurementSystem.metric), height: .constant(HeightValue.metric(170)))
}

