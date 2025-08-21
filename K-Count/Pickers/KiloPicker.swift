import SwiftUI

struct KiloPicker: View {
    @Binding var selectedValue: WeightValue
    

    private let integerRange = Array(30...200)
    private let fractionRange = Array(0...9)

    private var selectedInteger: Int {
        Int(selectedValue.asKilograms)
    }
    
    private var selectedFraction: Int {
        Int((selectedValue.asKilograms - Double(selectedInteger)) * 10)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Fixed: Display weight, not height
            Text(String(format: "Weight: %.1f kg", selectedValue.asKilograms))
                .font(.title3)
                .fontWeight(.semibold)
            
            HStack(spacing: 4) {
                // Integer part picker
                Picker("Kilograms", selection: .init(
                    get: { selectedInteger },
                    set: { newValue in
                        let newKg = Double(newValue) + Double(selectedFraction) / 10.0
                        selectedValue = .metric(newKg)
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
                        let newKg = Double(selectedInteger) + Double(newValue) / 10.0
                        selectedValue = .metric(newKg)
                    }
                )) {
                    ForEach(fractionRange, id: \.self) { value in
                        Text("\(value)")
                            .tag(value)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 60)
                
                Text("kg")
                    .font(.title3)
                    .fontWeight(.medium)
                    .padding(.leading, 8)
            }
        }
    }
}

struct KiloPickerPreview: View {
    @State private var weight = WeightValue.metric(70.5)
    
    var body: some View {
        VStack {
            KiloPicker(selectedValue: $weight)
                .frame(height: 200)
            
         
        }
    }
}

#Preview {
    KiloPickerPreview()
}
