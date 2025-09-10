import SwiftUI


struct ImperialTickView: View {
    let value: HeightValue.FootInches
    let isMajor: Bool
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 2) {
            Rectangle()
                .fill(isSelected ? .accent : .primary)
                .frame(width: 1, height: isMajor ? 40 : 30)
            
            
            if isMajor {
                Text("\(value.foot)'")
                    .font(.caption2)
                    .foregroundColor(isSelected ? .accent : .primary)
            }
        }
        
        
        .frame(width: 30)
    }
}

struct ImperialRulerPicker: View {
    @Binding var selectedValue: HeightValue
    // You need this to be optional, because we want the proxy to take us to a default value when the first appears.
    @State private var scrollPosition: Double?
    
    /// Returns an array FootInches that belong to the HeightValue enum:  [ FootInches(foot: 2, inches: 0),  ... , FootInches(foot:7, inches: 11)]
    private let ticks: [HeightValue.FootInches] = (2...7).flatMap { foot in
        (0...11).map { inch in
            HeightValue.FootInches(foot: foot, inches: inch)
        }
    }
    
    var body: some View {
        VStack {
            Text("Height: \(selectedValue.asFeetInches.foot)'\(selectedValue.asFeetInches.inches)\"")
                .font(.title3)
                .fontWeight(.semibold)
                .padding()
            
            GeometryReader { geometry in
                let centerX = geometry.size.width / 2
                Rectangle()
                    .fill(.accent)
                    .frame(width: 4, height: 25)
                    .position(x: centerX )
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 0) {
                            ForEach(ticks, id: \.self) { tick in
                                ImperialTickView(
                                    value: tick,
                                    isMajor: tick.inches == 0,
                                    isSelected: tick == selectedValue.asFeetInches
                                )
                            
                                .id(tick)
                                
                   
                          
                            }
                        }
                    }
                    
                    .scrollTargetLayout()
                    .contentMargins(.horizontal, centerX - 15)
                    
                    // The id has to be a Binding of the Ticks's Value, here it's Binding<HeightValue.FootInches>
                    .scrollPosition(id: .init(
                        get: { selectedValue.asFeetInches},
                        set: { newValue in
                            if let newValue = newValue {
                                selectedValue = .imperial(newValue)
                            }
                        }
                    ))
                    
                    .scrollTargetBehavior(.viewAligned)
                   
                    .onAppear {
                        proxy.scrollTo(selectedValue.asFeetInches)
                    }
                }
               
                
            
               
            }
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
            )
            .frame(height: 70)
            
        }
    }
}

struct TestView2: View {
    @State private var currentValue = HeightValue.imperial(HeightValue.FootInches(foot: 5, inches: 10))
    
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
