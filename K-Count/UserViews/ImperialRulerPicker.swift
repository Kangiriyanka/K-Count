import SwiftUI



struct ImperialRulerPicker: View {
    @Binding var selectedValue: HeightValue
    @State private var footInches: HeightValue.FootInches = .init(foot: 0, inches: 0)
    
    let ticks: [HeightValue.FootInches] = (2...8).flatMap { feet in
        (0..<12).map { inches in
            HeightValue.FootInches(foot: feet, inches: inches)
        }
    }
    
    var body: some View {
        VStack {
            Text("Height: \(footInches.foot)′ \(footInches.inches)″")
                .font(.title3)
                .fontWeight(.semibold)
                .padding()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(ticks, id: \.foot) { tick in
                        TickView(
                            value: Double(tick.foot) + Double(tick.inches)/12,
                            isMajor: tick.inches == 0,
                            isSelected: tick.foot == footInches.foot && tick.inches == footInches.inches
                        )
                        .onTapGesture {
                            footInches = tick
                            selectedValue = .imperial(tick)
                        }
                    }
                }
            }
        }
        .onAppear {
            // initialize footInches from selectedValue
            switch selectedValue {
            case .imperial(let fi):
                footInches = fi
            case .metric(let cm):
                let totalInches = cm / 2.54
                let f = Int(totalInches) / 12
                let i = Int(totalInches) % 12
                footInches = HeightValue.FootInches(foot: f, inches: i)
            }
        }
    }
}
struct TestView2: View {
    @State private var currentValue = HeightValue.imperial(.init(foot: 5, inches: 10))
    
    var body: some View {
        VStack(spacing: 20) {
          
            
            ImperialRulerPicker(selectedValue: $currentValue)
               
            
        }
        .padding()
    }
}

#Preview {
    TestView2()
}
