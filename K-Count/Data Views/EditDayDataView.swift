import SwiftUI

struct EditDayDataView: View {
    
    var day: Day
    @AppStorage("userSettings") var userSettings = UserSettings()
    
    @State private var weightInput: String = ""
    @State private var showingError = false
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @FocusState private var isWeightFocused: Bool
    @Environment(\.dismiss) private var dismiss
    
    private var dayCalories: Double {
        
        day.foodEntries.reduce(0) { sum, entry in
               sum + entry.totalCalories
           }
        
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Text("Weight")
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        TextField("0.0", text: $weightInput)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                        
                            .focused($isWeightFocused)
                            .limitDecimals($weightInput, decimalLimit: 1, prefix: 3)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    isWeightFocused = true
                                }
                            }
                        
                        Text(userSettings.weightPreference == .metric ? "kg" : "lbs")
                            .foregroundColor(.secondary)
                            .font(.body)
                    }
                } header: {
                    Text("Change your weight")
                }
                
                
                Section("Food Log"){
                    
                    ForEach(day.foodEntries) { foodEntry in
                        FoodEntryRow(foodEntry: foodEntry)
                    }
                  
                    HStack {
                        Text("Total").fontWeight(.semibold)
                        Spacer()
                        Text(String(format: "%.1f", dayCalories))
                     
                    }
                    
                }
                
            }
            .navigationTitle(day.formattedDate)
            .navigationBarTitleDisplayMode(.inline)
            .scrollDismissesKeyboard(.interactively)
            .alert(errorTitle, isPresented: $showingError) {
                Button("OK") { }
            } message: {
                Text(errorMessage)
            }
            .toolbar {
              
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveWeight()
                    }
                    .fontWeight(.semibold)
                    .disabled(weightInput.isEmpty)
                }
            }
        }
        .onAppear {
            setupInitialWeight()
        }
    }
    
    // Display the weight (lbs, kg) inside userSettings as a String.
    private func setupInitialWeight() {
        let initialWeight = day.weight > 0 ? day.weight : userSettings.weight
        
        if initialWeight > 0 {
            // Convert to display units if needed
            let displayWeight = userSettings.weightPreference == .metric ?
                initialWeight : initialWeight / 0.453592
            weightInput = String(format: "%.1f", displayWeight)
        } else {
            weightInput = ""
        }
        
        // Focus the text field after a brief delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isWeightFocused = true
        }
    }
    
    private func saveWeight() {
        guard !weightInput.isEmpty else {
            inputError(title: "Missing Weight", message: "Please enter your weight")
            return
        }
        
        guard let inputWeight = Double(weightInput) else {
            inputError(title: "Invalid Weight", message: "Please enter a valid number")
            return
        }
        
        guard inputWeight > 0 && inputWeight <= (userSettings.weightPreference == .metric ? 1000 : 2200) else {
            let maxWeight = userSettings.weightPreference == .metric ? "1000 kg" : "2200 lbs"
            inputError(title: "Invalid Weight", message: "Please enter a weight between 0 and \(maxWeight)")
            return
        }

        // Convert to kg if needed (input is in display units)
        let weightInKg = userSettings.weightPreference == .metric ?
            inputWeight : inputWeight * 0.453592

        // Save as kg
        day.weight = weightInKg

        // Update user's current weight if this is today's entry
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyy"
        let today = formatter.string(from: Date.now)
        if day.formattedDate == today {
            userSettings.weight = weightInKg
        }

        dismiss()
    }
    
    private func inputError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

#Preview {
    EditDayDataView(day: Day.example)
}
