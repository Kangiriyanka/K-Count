//
//  EditPersonView.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/10.
//

import SwiftUI

struct ProfileView: View {
    
    @AppStorage("userSettings") var userSettings = UserSettings()

    @State private var editableSettings = UserSettings()
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showError = false
    @State private var showHeightView = false
    @State private var showWeightView = false
    
    var heightText: String {
        let height = HeightValue.metric(editableSettings.height)
        if editableSettings.heightPreference == .metric {
            return height.centimetersDescription
        } else {
            return height.feetInchesDescription
        }
    }
    
    var weightText: String {
        let weight = WeightValue.metric(editableSettings.weight)
        if editableSettings.weightPreference == .metric {
            return weight.kilogramsDescription
        } else {
            return weight.poundsDescription
        }
    }
 
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                
                Section("What's your name?") {
                    
                    HStack {
                        Text("Name")
                        TextField("Name", text: $editableSettings.name)
                            .keyboardType(.default)
                            .multilineTextAlignment(.trailing)
                            .limitText($editableSettings.name, to: 30)
                            
                    }
                }
                
                Section("Physical Stats (Age - Weight - Height)") {
                    
                    HStack {
                        Text("Birthday")
                        DatePicker(
                               "",
                               selection: $editableSettings.birthday,
                               in: Calendar.current.date(byAdding: .year, value: -100, to: Date())!...Date(),
                               displayedComponents: .date
                           )
                           .datePickerStyle(.compact)
                    }
                    
                    HStack {
                        Text("Height")
                        Spacer()
                        Text(heightText)
                    }
                    .onTapGesture {
                        showHeightView.toggle()
                    }
                    .sheet(isPresented: $showHeightView) {
                        CustomHeightPicker(
                            preference: $editableSettings.heightPreference,
                            height: .init(
                                
                                get: {HeightValue.metric(editableSettings.height)},
                                set: { newValue in editableSettings.height = newValue.asCentimeters}
                            )
                            
                            
                        )
                        .presentationDetents([.fraction(0.40)])
                    }
                  
                    
                    HStack {
                        Text("Weight")
                        Spacer()
                        Text(weightText)
                    }
                    .onTapGesture {
                        showWeightView.toggle()
                    }
                    .sheet(isPresented: $showWeightView) {
                        CustomWeightPicker(
                            preference: $editableSettings.weightPreference,
                            weight: .init(
                                
                                get: {WeightValue.metric(editableSettings.weight)},
                                set: { newValue in editableSettings.weight = newValue.asKilograms}
                            )
                            
                            
                        )
                        .presentationDetents([.fraction(0.40)])
                    }
                    
                    Picker("Sex assigned at birth", selection: $editableSettings.sex) {
                        ForEach (UserSettings.Sex.allCases, id: \.self) { sex in
                            Text(sex.rawValue)
                                .tag(sex)
                        }
                    }
                    
                    Picker("Lifestyle", selection: $editableSettings.activityLevel) {
                        ForEach (UserSettings.ActivityLevel.allCases, id: \.self) { activityLevel in
                            Text(activityLevel.rawValue)
                                .tag(activityLevel)
                        }
                    }
                }
            }
            .toolbar {
               
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if validateUserDetails() {
                            saveChanges()
                            dismiss()
                        }
                    }
                    .fontWeight(.semibold)
                }
            }
            .alert(errorTitle, isPresented: $showError) {
                Button("OK") {}
            } message: {
                Text(errorMessage)
            }
            .navigationTitle("My Information")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
             
                loadCurrentSettings()
            }
        }
    }
    
    private func loadCurrentSettings() {
        editableSettings = userSettings
        
    }
    
    private func saveChanges() {
        userSettings = editableSettings
        
  
        
    }
    
    private func validateUserDetails() -> Bool {
        if editableSettings.name.count < 3 {
            inputError(title: "Invalid Name", message: "Please enter 2 or more characters")
            return false
        }
        return true
    }

    private func inputError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showError = true
    }
    
   
}

#Preview {
    ProfileView()
}
