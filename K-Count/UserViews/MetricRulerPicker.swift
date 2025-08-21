import SwiftUI

struct TickView: View {
    let value: Double
    let isMajor: Bool
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 2) {
            Rectangle()
                .fill(isSelected ? .accent : .primary)
                .frame(width: 1, height: isMajor ? 50 : 40)
            
            if isMajor {
                Text("\(value)")
                    .font(.caption2)
                    .foregroundColor(isSelected ? .accent : .primary)
            }
        }
      
        .frame(width: 30)
    }
}

struct MetricRulerPicker: View {
    @Binding var selectedValue: HeightValue
    @State private var scrollPosition: Double? = 150
    
    var body: some View {
        
     
        Text("Height: \(Int(selectedValue.asCentimeters)) cm")
                .font(.title3)
                .fontWeight(.semibold)
                .padding()
               
        GeometryReader { geometry in
            let centerX = geometry.size.width / 2
            
            ScrollView(.horizontal, showsIndicators: false) {
                // HStack is the outermost layout
                HStack(spacing: 0) {
                    ForEach(Array(stride(from: 60.0, through: 280.0, by: 1.0)), id: \.self) { value in
                        TickView(
                            value: value,
                            isMajor: value.truncatingRemainder(dividingBy: 5) == 0,
                            isSelected: value == selectedValue.asCentimeters
                        )
                    }
                }
            
                .scrollTargetLayout()
            }
           
            // Add space to both sides of the HStack
            // This will allow you to center the ticks at both extremities
            .contentMargins(.horizontal, (centerX-15))
            .scrollPosition(id: $scrollPosition)
            .scrollTargetBehavior(.viewAligned)
            .onAppear {
                scrollPosition = selectedValue.asCentimeters
            }
            .onChange(of: scrollPosition) { _, newPosition in
                if let newPosition, newPosition != selectedValue.asCentimeters {
                    selectedValue = .metric(newPosition)
                }
            }
            .onChange(of: selectedValue) { _, newValue in
                if scrollPosition != newValue.asCentimeters {
                    scrollPosition = newValue.asCentimeters
                }
            }
            
            Rectangle()
                .fill(.accent)
                .frame(width: 4, height: 25)
                .position(x: centerX, y: 0)
        }
     
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        )
   
        .frame(height: 100)
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
