import SwiftUI

struct CustomWeightPicker: View {
    
  
    
    @Binding var preference: MeasurementSystem
    @Binding var weight: WeightValue
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
        HStack {
            Button(""){}
            Spacer()
            Text("Your Weight").fontWeight(.bold)
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
            
            KiloPicker(selectedValue: $weight)
            
        }
        
        else {
            
            PoundPicker(selectedValue: $weight)
            
        }
        
    }
}

#Preview {
    WeightPreviewWrapper()
}

private struct WeightPreviewWrapper: View {
    @State private var preference: MeasurementSystem = .metric
    @State private var weight: WeightValue = .metric(100)
    
    var body: some View {
        CustomWeightPicker(
            preference: $preference,
            weight: $weight
        )
    }
}
