//
//  OnboardingView.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2025/07/06.
//

import SwiftUI

struct OnboardingView: View {
    
    @AppStorage("userSettings") var userSettings = UserSettings()
    @AppStorage("hasOnboarded") var hasOnboarded: Bool = false
    @State private var name: String = ""
    @State private var height: String = ""
    @State private var weight: String = ""
    @State private var age: String = ""
    @State private var sexAssigned: UserSettings.Sex = .male
    @State private var activityLevel: UserSettings.ActivityLevel = .sedentary
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showError = false
    
    
    
    var body: some View {
        NavigationStack {
            
            
          
            
            
            Form {
                
                Text("Welcome to K-Count!").font(.title).bold()
                
                
                
                
                Section("Personal information") {
                    
                    
                    HStack {
                        Text("Name")
                        TextField("Name", text: $name)
                            .keyboardType(.default)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    Picker("Sex assigned at birth", selection: $sexAssigned) {
                        
                        ForEach (UserSettings.Sex.allCases, id: \.self) { sex in
                            Text(sex.rawValue)
                                .tag(sex)
                        }
                        
                    }
                }
                
                Section("Physical information") {
                    HStack {
                        
                        Text("Age")
                        TextField("Enter your age", text: $age)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                    }
                    
                    HStack {
                        Text("Height")
                        TextField("Enter your height", text: $height)
                            .multilineTextAlignment(.trailing)
                        
                            .keyboardType(.decimalPad)
                    }
                    
                    HStack {
                        Text("Weight")
                        
                        TextField("Enter your weight", text: $weight)
                            .multilineTextAlignment(.trailing)
                        
                        
                            .keyboardType(.decimalPad)
                    }
                    
                    
                
                
                
                
                Picker("Lifestyle", selection: $activityLevel) {
                    
                    ForEach (UserSettings.ActivityLevel.allCases, id: \.self) { activityLevel in
                        Text(activityLevel.rawValue)
                            .tag(activityLevel)
                    }
                    
                }
            }
                        
                    
                    
                    
                    
                    Button("All Set!") {
                        
                        if validateUserDetails() {
                            userSettings.name = name
                            userSettings.age = Int(age) ?? 0
                            userSettings.height = Double(height) ?? 0
                            userSettings.weight = Double(weight) ?? 0
                            userSettings.sex = sexAssigned
                            userSettings.activityLevel = activityLevel
                            hasOnboarded = true
                        }
                        
                        
                        
                    }
                    .frame(maxWidth: .infinity)
                    .listRowBackground(EmptyView())
                    .buttonStyle(AddButton())
                }
            
                .alert(errorTitle, isPresented: $showError) {
                    Button("OK") { }
                } message: {
                    Text(errorMessage)
                }
            }
            
        }
    
    
    
    // MARK: - Validates the user input.
    func validateUserDetails() -> Bool {
        
        if name.count < 2 {
            inputError(title: "Invalid Name", message: "Please enter 2 or more characters")
            return false
        }
        
        guard isValidAge() != nil
        else
        
        {
            inputError(title: "Invalid Age", message: "Please enter a valid age")
            age = ""
            return false
        }
        guard isValidWeight() != nil else {
            inputError(title: "Invalid weight", message: "Please enter a valid weight ")
            weight = ""
            return false
        }
        guard isValidHeight() != nil else {
            inputError(title: "Invalid height", message: "Please enter a valid height ")
            height = ""
            return false
        }
        
        return true
        
        
     }
        
    
    
    
    
    func isValidAge() -> Int? {
        
        guard let age = Int(age), age > 0, age <= 150 else { return nil}
        return age
    }
    
    
    func isValidWeight() -> Double? {
        
        guard let weight = Double(weight), weight >= 0.0 && weight <= 1000.0 else { return nil}
        return weight
    }
    
    func isValidHeight() -> Double? {
        guard let height = Double(height), height >= 0.0 && height <= 300.0 else { return nil}
        return height
        
        
    }
    
    
    func inputError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showError = true
    }
}

    

#Preview {
    OnboardingView()
    
}
