import SwiftUI

struct EditCurrentWeightView: View {
    
    var day: Day
    @AppStorage("userSettings") var userSettings = UserSettings()
    
    @State private var weightInput: String = ""
    @State private var showingError = false
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @FocusState private var isWeightFocused: Bool
    @Environment(\.dismiss) private var dismiss
    
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
                            .onChange(of: weightInput) { oldValue, newValue in
                                // Limit input to reasonable format
                                let filtered = newValue.filter { "0123456789.".contains($0) }
                                if filtered != newValue {
                                    weightInput = filtered
                                }
                                
                                // Limit to one decimal point and reasonable length
                                let components = filtered.components(separatedBy: ".")
                                if components.count > 2 {
                                    weightInput = oldValue
                                } else if components.count == 2 && components[1].count > 1 {
                                    weightInput = components[0] + "." + String(components[1].prefix(1))
                                } else if components[0].count > 4 {
                                    weightInput = String(components[0].prefix(4)) + (components.count > 1 ? "." + components[1] : "")
                                }
                            }
                        
                        Text(userSettings.weightPreference == .metric ? "kg" : "lbs")
                            .foregroundColor(.secondary)
                            .font(.body)
                    }
                } header: {
                    Text("Enter your weight")
                } footer: {
                    Text("Your weight will be saved for \(day.formattedDate)")
                        .font(.caption)
                }
            }
            .navigationTitle("Add Weight")
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
    
    private func setupInitialWeight() {
        let initialWeight = day.weight > 0 ? day.weight : 0.0
        
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
        let todayString = DateFormatter.localizedString(from: Date(), dateStyle: .long, timeStyle: .none)
        if day.formattedDate == todayString {
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
    EditCurrentWeightView(day: Day.example)
}
