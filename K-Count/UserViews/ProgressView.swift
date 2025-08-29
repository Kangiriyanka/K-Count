import SwiftUI
import SwiftData

struct ProgressView: View {
    @AppStorage("userSettings") var userSettings = UserSettings()
    @Query(filter: #Predicate<Day> { day in
        day.weight > 0}, sort: [SortDescriptor(\Day.date)]) var days : [Day]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ChartView(days: days)
                    
                    HStack {
                        Spacer()
                        
                        VStack {
                            Text("Current weight")
                                .italic()
                                .foregroundStyle(.secondary)
                                .font(.caption2)
                            
                            let weightValue = WeightValue.metric(userSettings.weight)
                            Text(weightValue.display(for: userSettings.weightPreference))
                                .font(.title)
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
            }
        }
    }
}

#Preview {
    ProgressView()
        .modelContainer(Day.previewContainer())
}
