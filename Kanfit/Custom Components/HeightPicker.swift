//
//  HeightPicker.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2025/07/09.
//

import SwiftUI

struct HeightPicker: View {
    
    
    @State private var measurementPreference = "Imperial"
    var body: some View {
        VStack {
            
            Picker("System", selection: $measurementPreference) {
                       Text("Imperial").tag(0)
                       Text("Metric").tag(1)
                     
                   }
                   .pickerStyle(.segmented)

                  
               }
           }
    }


#Preview {
    HeightPicker()
}
