import SwiftUI

struct PoundPicker: View {
    @Binding var selectedValue: WeightValue
    
    @State private var integerPart: Int
    @State private var fractionPart: Int
    
    private let integerRange = Array(50...500)
    private let fractionRange = Array(0...9)
    
    init(selectedValue: Binding<WeightValue>) {
        _selectedValue = selectedValue
        let lbs = selectedValue.wrappedValue.asPounds
        _integerPart = State(initialValue: Int(lbs))
        _fractionPart = State(initialValue: Int((lbs * 10).rounded()) % 10)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text(String(format: "Weight: %.1f lbs", selectedValue.asPounds))
                .font(.title3)
                .fontWeight(.semibold)
            
            HStack(spacing: 4) {
                Picker("Pounds", selection: $integerPart) {
                    ForEach(integerRange, id: \.self) { value in
                        Text("\(value)").tag(value)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 100)
                .onChange(of: integerPart) { _,_ in updateValue() }
                
                Text(".")
                    .font(.title2)
                    .fontWeight(.medium)
                
                Picker("Decimal", selection: $fractionPart) {
                    ForEach(fractionRange, id: \.self) { value in
                        Text("\(value)").tag(value)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 60)
                .onChange(of: fractionPart) { _,_ in updateValue() }
                
                Text("lbs")
                    .font(.title3)
                    .fontWeight(.medium)
                    .padding(.leading, 8)
            }
        }
    }
    
    private func updateValue() {
        let newLbs = Double(integerPart) + Double(fractionPart) / 10.0
        selectedValue = .imperial(newLbs)
    }
}

struct PoundPickerPreview: View {
    @State private var weight = WeightValue.imperial(130.5)
    
    var body: some View {
        PoundPicker(selectedValue: $weight)
            .frame(height: 200)
    }
}

#Preview {
    PoundPickerPreview()
}
