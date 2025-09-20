import SwiftUI

struct TickView: View {
    let value: Double
    let isMajor: Bool
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 2) {
            Rectangle()
                .fill(isSelected ? .accent : .primary)
                .frame(width: isMajor ? 2 : 1, height: isMajor ? 35 : 40)
            
            if isMajor {
                Text(String(format: "%.0f", value))                    .font(.caption2)
                    .foregroundColor(isSelected ? .accent : .primary)
            }
        }
      
        .frame(width: 30)
    }
}


struct MetricRulerPicker: View {
    @Binding var selectedValue: HeightValue
    @State private var scrollPosition: Double?
    private let ticks: [Double] = Array(stride(from: 60.0, through: 240.0, by: 1.0))
    
    private func nearestTick(to value: Double) -> Double {
            return ticks.min(by: { abs($0 - value) < abs($1 - value) }) ?? value
        }
    
    var body: some View {
        
     
        Text("Height: \(Int(selectedValue.asCentimeters)) cm")
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
                            TickView(
                                value: tick,
                                isMajor: tick.truncatingRemainder(dividingBy: 5) == 0,
                                isSelected:  tick == nearestTick(to: selectedValue.asCentimeters)
                            )
                            .id(tick)
                          
                       
                        }
                    }
                    .scrollTargetLayout()
                    .contentMargins(.horizontal, centerX - 15)
                }
                
            
               
                .scrollTargetBehavior(.viewAligned)
                .scrollPosition(id: .init(
                    get: { nearestTick(to: selectedValue.asCentimeters)},
                    set: { newValue in
                        if let newValue = newValue {
                            selectedValue = .metric(newValue)
                        }
                    }
                ))
              
                .onAppear {
                    
                    
                    proxy.scrollTo(nearestTick(to: selectedValue.asCentimeters), anchor: .center)
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

struct TestView: View {
    @State private var currentValue = HeightValue.metric(170.0)
    
    var body: some View {
        VStack(spacing: 20) {
          
            
            MetricRulerPicker(selectedValue: $currentValue)
               
            
        }
        .padding()
    }
}

#Preview {
    TestView()
}
