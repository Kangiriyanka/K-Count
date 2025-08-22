//
//  EditPersonView.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/10.
//

import SwiftUI

struct UserSettingsView: View {
    
    @AppStorage("userSettings") var userSettings = UserSettings()

    @State private var editableSettings = UserSettings()
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showError = false
    @State private var showHeightView = false
    @State private var hasPickedHeight = false
    
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
                        Text(HeightValue.metric(editableSettings.height).centimetersDescription)
                    }
                    
                    HStack {
                        Text("Weight")
                        Spacer()
                        Text(WeightValue.metric(editableSettings.weight).kilogramsDescription)
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
                    Button("Save",systemImage: "checkmark.circle") {
                        if validateUserDetails() {
                            saveChanges()
                            dismiss()
                        }
                    }
                }
            }
            .alert(errorTitle, isPresented: $showError) {
                Button("OK") {}
            } message: {
                Text(errorMessage)
            }
            .navigationTitle("User Information")
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
        if editableSettings.name.count < 2 {
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
    UserSettingsView()
}
