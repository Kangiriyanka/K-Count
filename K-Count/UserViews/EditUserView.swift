//
//  EditPersonView.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/10.
//

import SwiftUI

struct EditUserView: View {
    
    
    @AppStorage("userSettings") var userSettings = UserSettings()
    @State private var name: String = ""
    @State private var height: String = ""
    @State private var weight: String = ""
    @State private var age: String = ""
    @State private var sexAssigned: UserSettings.Sex = .male
    @State private var activityLevel: UserSettings.ActivityLevel = .sedentary
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showError = false
    
   
 
    
    
    @Environment(\.dismiss) private var dismiss
    
    
    
    var body: some View {
        NavigationStack {
            Form {
                
                Section("General information") {
                    
                    HStack {
                         Text("Name")
                             // fixed label width
                         TextField("Name", text: $name)
                             .multilineTextAlignment(.trailing)
                     }
                    
               
                    
                   
                }
                Section("Physical Stats (Age - Weight - Height)") {
                    
                    
                    HStack {
                        Text("Age")
                   
                        TextField("Age", text: $age)
                            .multilineTextAlignment(.trailing)
                    }
                        
                        .limitDecimals($age, decimalLimit: 0, prefix: 3)
                        .keyboardType(.numberPad)
                    
                    HStack {
                        Text("Height")
                        TextField("Weight", text: $weight)
                            .limitDecimals($weight, decimalLimit: 1, prefix: 4)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                        
                    }
                    HStack {
                        Text("Height")
                        TextField("Height", text: $height)
                            .limitDecimals($height, decimalLimit: 1, prefix: 4)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    Picker("Lifestyle", selection: $activityLevel) {
                        
                        ForEach (UserSettings.ActivityLevel.allCases, id: \.self) { activityLevel in
                            Text(activityLevel.rawValue)
                                .tag(activityLevel)
                        }
                        
                    }
                    
                }
                
                
              
                
                Section("Other") {
                    
                }
                
                
                
            }
            .onAppear {
                name = userSettings.name
                height = String(userSettings.height)
                weight = String(userSettings.weight)
                age = String(userSettings.age)
                activityLevel = userSettings.activityLevel
                sexAssigned = userSettings.sex
            }
            .toolbar {
                ToolbarItem {
                    Button("Save", systemImage: "checkmark.circle") {
                        
                        if validateUserDetails() {
                            userSettings.name = name
                            userSettings.age = Int(age) ?? 0
                            userSettings.height = Double(height) ?? 0
                            userSettings.weight = Double(weight) ?? 0
                            userSettings.sex = sexAssigned
                            userSettings.activityLevel = activityLevel
                          
                        }
                        dismiss()
                      
                        
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
        }
        
    }
    
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

    EditUserView()
}
