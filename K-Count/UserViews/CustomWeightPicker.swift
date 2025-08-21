import SwiftUI

struct CustomWeightPicker: View {
    
    enum MeasurementSystem: String, CaseIterable {
        case imperial = "Imperial"
        case metric = "Metric"
    }
    
    @State private var measurementPreference: MeasurementSystem = .imperial
    @Binding var weight: Double
    
    var body: some View {
        
        HStack {
            Button("", systemImage: "xmark.circle") {}
            Spacer()
            Text("Your Weight").fontWeight(.bold)
            Spacer()
            Button("", systemImage: "checkmark.circle") {
              
                
            }
        }
        .padding()
        Divider()
        Picker("System", selection: $measurementPreference) {
            ForEach(MeasurementSystem.allCases, id: \.self) { system in
                Text(system.rawValue).tag(system)
            }
        }
        .pickerStyle(.segmented)
        .padding()
        if measurementPreference == .metric {
            
            Text("Weight in kilos")
            
        }
        
        else {
            
            Text("Weight in lbs")
            
        }
        
    }
}

#Preview {
    CustomWeightPicker(weight: .constant(50))
}
