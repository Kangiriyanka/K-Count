import SwiftUI
import SwiftData

struct ProgressView: View {
    @AppStorage("userSettings") var userSettings = UserSettings()
    @Query(filter: #Predicate<Day> { day in
        day.weight > 0}, sort: [SortDescriptor(\Day.date)]) var days : [Day]
    
    @State private var showStrategyView = false
    
    private var currentWeight: WeightValue {
        WeightValue.metric(userSettings.weight)
    }
    
    private var goalWeight: WeightValue {
        WeightValue.metric(userSettings.goalWeight)
    }
    
    private var toGoal: WeightValue {
        WeightValue.metric(abs(userSettings.weight - userSettings.goalWeight))
    }
    
    private var toGoalString: String {
        WeightValue.metric(abs(userSettings.weight - userSettings.goalWeight)).display(for: userSettings.weightPreference)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
           
                VStack(alignment: .center) {
                    ChartView(days: days)
                      
                    
                    HStack {
                     
                        VStack {
                            Text("Current")
                                .italic()
                                .foregroundStyle(.secondary)
                                .font(.caption2)
                            
                            Text(currentWeight.display(for: userSettings.weightPreference))
                                .font(.title3)
                                .bold()
                                .padding(.bottom, 4)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.accent.opacity(0.08))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.accent, lineWidth: 0.8)
                        )
                        
                       
                        VStack {
                            Text("Goal")
                                .italic()
                                .foregroundStyle(.secondary)
                                .font(.caption2)
                            
                            Text(goalWeight.display(for: userSettings.weightPreference))
                                .font(.title3)
                                .bold()
                                .padding(.bottom, 4)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.burntOrange.opacity(0.08))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.burntOrange, lineWidth: 0.8)
                        )
                        
                      
                        VStack {
                            Text("To Goal")
                                .italic()
                                .foregroundStyle(.secondary)
                                .font(.caption2)
                            
                            Text(toGoalString)
                                .font(.title3)
                                .bold()
                                .padding(.bottom, 4)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.gray.opacity(0.05))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.gray.opacity(0.6), lineWidth: 0.8)
                        )
                    }
                    
                    Divider().padding(.vertical, 10)
                    VStack() {
                        
                    
                            
                        Button("Estimate time to goal", systemImage: "clock") {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.85, blendDuration: 0.5)) {
                                showStrategyView.toggle()
                            }
                            
                        }
                        
                        .padding(5)
                        .fontWeight(.semibold)
                       
                        .smallDataCardStyle()
                        
                        
                       
                        
                        if showStrategyView {
                            StrategyView(current: currentWeight, goal: goalWeight, difference: toGoal)
                                .transition(.scale)
                        }
                    }
                }
                .padding()
                .navigationBarTitle("My Progress", displayMode: .inline)
            }
        }
    }
}

#Preview {
    ProgressView()
        .modelContainer(Day.previewContainer())
}
