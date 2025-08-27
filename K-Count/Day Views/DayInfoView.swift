import SwiftUI

struct DayInfoView: View {
    
    var day: Day
    var totalCalories: String
    var remainingCalories: String
    @AppStorage("userSettings") var userSettings = UserSettings()
    private var dayWeight: String {
        let weightValue = WeightValue.metric(day.weight)
        return weightValue.display(for: userSettings.weightPreference)
    }
    private var userWeight: String {
        let weightValue = WeightValue.metric(userSettings.weight)
        return weightValue.display(for: userSettings.weightPreference)
    }
    
    var body: some View {
        VStack {
            HStack {
                Group {
                    VStack {
                        Text("Weight")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        if day.weight == 0.0 {
                            Text(Image(systemName: "pencil"))
                                .overlay(
                                    NavigationLink(destination: EditCurrentWeightView(day: day), label: {})
                                        .opacity(0)
                                )
                        } else {
                        
                            Text(dayWeight)
                                .bold()
                                .overlay(
                                    NavigationLink(destination: EditCurrentWeightView(day: day), label: {})
                                        .opacity(0)
                                )
                        }
                    }
                    
                    Divider()
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                    
                    VStack {
                        Text("Calories")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(totalCalories)
                            .bold()
                            .contentTransition(.numericText())
                    }
                    
                    Divider()
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                    
                    VStack {
                        Text("Remaining")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(remainingCalories)
                            .bold()
                            .contentTransition(.numericText())
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    DayInfoView(day: Day.example, totalCalories: "1000", remainingCalories: "500")
}
