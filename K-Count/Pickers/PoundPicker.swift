import SwiftUI

struct PoundPicker: View {
    @Binding var selectedValue: WeightValue
    

    private let integerRange = Array(50...500)
    private let fractionRange = Array(0...9) 
    
 
    private var selectedInteger: Int {
        Int(selectedValue.asPounds)
    }
    
    private var selectedFraction: Int {
        Int((selectedValue.asPounds - Double(selectedInteger)) * 10)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Fixed: Display pounds, not height
            Text(String(format: "Weight: %.1f lbs", selectedValue.asPounds))
                .font(.title3)
                .fontWeight(.semibold)
            
            HStack(spacing: 4) {
                // Integer part picker
                Picker("Pounds", selection: Binding(
                    get: { selectedInteger },
                    set: { newValue in
                        let newPounds = Double(newValue) + Double(selectedFraction) / 10.0
                        selectedValue = .imperial(newPounds)
                    }
                )) {
                    ForEach(integerRange, id: \.self) { value in
                        Text("\(value)")
                            .tag(value)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 100)
                
                Text(".")
                    .font(.title2)
                    .fontWeight(.medium)
                
                // Fraction part picker
                Picker("Decimal", selection: Binding(
                    get: { selectedFraction },
                    set: { newValue in
                        let newPounds = Double(selectedInteger) + Double(newValue) / 10.0
                        selectedValue = .imperial(newPounds)
                    }
                )) {
                    ForEach(fractionRange, id: \.self) { value in
                        Text("\(value)")
                            .tag(value)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 60)
                
                Text("lbs")
                    .font(.title3)
                    .fontWeight(.medium)
                    .padding(.leading, 8)
            }
        }
    }
}

struct PoundPickerPreview: View {
    @State private var weight = WeightValue.imperial(130.5)
    
    var body: some View {
        VStack {
            PoundPicker(selectedValue: $weight)
                .frame(height: 200)
            
         
        }
    }
}

#Preview {
    PoundPickerPreview()
}
