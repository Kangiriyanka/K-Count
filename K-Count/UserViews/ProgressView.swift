import SwiftUI
import SwiftData





struct ProgressView: View {
    @AppStorage("userSettings") var userSettings = UserSettings()
    @Query(filter: #Predicate<Day> { day in
        day.weight > 0}, sort: [SortDescriptor(\Day.date)]) var days : [Day]
    
    
    @State private var showStrategyView = false
    private var currentWeight:  WeightValue  { WeightValue.metric(userSettings.weight)
    }
    
    private var goalWeight: WeightValue  {
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
                VStack(alignment: .leading) {
                    ChartView(days: days)
                    
                    HStack() {
                        Spacer()
                        
                        VStack {
                            Text("Current")
                                .italic()
                                .foregroundStyle(.secondary)
                                .font(.caption2)
                            
                            
                            Text(currentWeight.display(for: userSettings.weightPreference))
                                .font(.title3)
                                .bold()
                                .padding(.bottom, 4)
                                .overlay(
                                    Color.burntOrange
                                        .frame(height: 3),
                                    alignment: .bottom
                                )
                        }
                        .smallDataCardStyle()
                        
                        VStack {
                            Text("Goal")
                                .italic()
                                .foregroundStyle(.secondary)
                                .font(.caption2)
                            
                            
                            Text(goalWeight.display(for: userSettings.weightPreference))
                                .font(.title3)
                                .bold()
                                .padding(.bottom, 4)
                                .overlay(
                                    Color.burntOrange
                                        .frame(height: 3),
                                    alignment: .bottom
                                )
                        }
                        .smallDataCardStyle()
                        
                        VStack {
                            
                            Text("To Goal")
                                .italic()
                                .foregroundStyle(.secondary)
                                .font(.caption2)
                            
                            Text(toGoalString)
                                .font(.title3)
                                .bold()
                                .padding(.bottom, 4)
                                .overlay(
                                    Color.burntOrange
                                        .frame(height: 3),
                                    alignment: .bottom
                                )
                        }
                        .smallDataCardStyle()
                        
                        Spacer()
                        
                        
                        
                        
                        
                        
                        
                        
                    }
                    
                }
                .navigationBarTitle("My Progress", displayMode: .inline)
                Button("Show Strategy") {
                    showStrategyView.toggle()
                }
                
                if showStrategyView {
                    StrategyView(current: currentWeight, goal: goalWeight, difference: toGoal )
                }
            
                
               
            }
        }
    }
    
    
   
    
}


#Preview {
    ProgressView()
        .modelContainer(Day.previewContainer())
}
