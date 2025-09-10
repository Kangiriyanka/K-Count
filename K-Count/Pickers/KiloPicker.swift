import SwiftUI

struct KiloPicker: View {
    @Binding var selectedValue: WeightValue
    
    @State private var integerPart: Int
    @State private var fractionPart: Int
    
    private let integerRange = Array(30...200)
    private let fractionRange = Array(0...9)
    
    // You could do with with onAppear
    init(selectedValue: Binding<WeightValue>) {
        _selectedValue = selectedValue
        let kg = selectedValue.wrappedValue.asKilograms
        _integerPart = State(initialValue: Int(kg))
        _fractionPart = State(initialValue: Int((kg * 10).rounded()) % 10)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text(String(format: "Weight: %.1f kg", selectedValue.asKilograms))
                .font(.title3)
                .fontWeight(.semibold)
            
            HStack(spacing: 4) {
                Picker("Kilograms", selection: $integerPart) {
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
                .onChange(of: fractionPart) { _,_  in updateValue() }
                
                Text("kg")
                    .font(.title3)
                    .fontWeight(.medium)
                    .padding(.leading, 8)
            }
        }
    }
    
    
    private func updateValue() {
        let newKg = Double(integerPart) + Double(fractionPart) / 10.0
        selectedValue = .metric(newKg)
    }
}

struct KiloPickerPreview: View {
    @State private var weight = WeightValue.metric(70.5)
    
    var body: some View {
        KiloPicker(selectedValue: $weight)
            .frame(height: 200)
    }
}

#Preview {
    KiloPickerPreview()
}
