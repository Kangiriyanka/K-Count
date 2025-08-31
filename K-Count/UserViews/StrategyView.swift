//
//  StrategyView.swift
//  K-Count
//
//  Created by Kangiriyanka The Single Leaf on 2025/08/29.
//

import SwiftUI


enum Strategy: String, CaseIterable {
    case steady
    case standard
    case hardcore
    
    // Standard strategy: lose 0.5lbs for 7 days.
    var kilogramsPerWeek: Double {
        
        
        switch self {
            
        case .steady:
            
            return 0.03239942857
            
        case .standard:
            
            return 0.06479885714
            
            
        case .hardcore:
            
            return 0.09719828571
            
        }
    }
    
    func description(isLosing: Bool) -> String {
            switch self {
            case .steady:
                return isLosing
                    ? "Consume about 250 fewer calories per day"
                    : "Consume about 250 extra calories per day"
            case .standard:
                return isLosing
                    ? "Consume about 500 fewer calories per day"
                    : "Consume about 500 extra calories per day"
            case .hardcore:
                return isLosing
                    ? "Consume about 750 fewer calories per day"
                    : "Consume about 750 extra calories per day"
            }
        }
    
    
    
    
    
    
}
struct StrategyView: View {
    
    @State private var goal: WeightValue
    @State private var current: WeightValue
    @State private var difference: WeightValue
    @State private var selectedStrategy: Strategy = .standard
    
    private var progressResult: String {
        let days = calculateDays(difference: difference, strategy: selectedStrategy)
        let today = Date()

        guard let futureDate = Calendar.current.date(byAdding: .day, value: Int(days), to: today) else {
            return ""
        }

        let formatter = DateFormatter()
        formatter.dateStyle = .medium

        let dateString = formatter.string(from: futureDate)

        return """
        Goal can be reached in about \(Int(days)) days \
        (\(Int(days / 7)) weeks) on \(dateString).
        """
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 0) {
                
                HStack {
                    Text("Strategy")
                        .font(.headline)
                    
                    Picker("Strategy", selection: $selectedStrategy) {
                        ForEach(Strategy.allCases, id: \.self) { strategy in
                            Text(strategy.rawValue.capitalized)
                                .tag(strategy)
                        }
                    }
                    
                }
                
                Text(selectedStrategy.description(isLosing: goal.asKilograms < current.asKilograms ))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Divider()
            VStack(alignment: .leading, spacing: 4) {
                Text("Timeline")
                    .font(.headline)
                Text(progressResult)
                    
                    .font(.body)
            }
        }
        .padding(.bottom, 5)
        .smallDataCardStyle()
       
     
        
        
        
    }
    
    init(current: WeightValue, goal: WeightValue, difference: WeightValue) {
        self.goal = goal
        self.current = current
        self.difference = difference
    }
    
    
    // Difference: Weight to lose/gain
    // Find how many days required to get there
    private func calculateDays(difference: WeightValue, strategy: Strategy) -> Double {
        
        let kilos: Double = strategy.kilogramsPerWeek
        
        return (difference.asKilograms / kilos).rounded(.down)
        

    }
}

#Preview {
    StrategyView(current: WeightValue.metric(100), goal: WeightValue.metric(90), difference: WeightValue.metric(10))
}
