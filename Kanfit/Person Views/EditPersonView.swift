//
//  EditPersonView.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/10.
//

import SwiftUI

struct EditPersonView: View {
    
    @Bindable var person: Person
    @State private var age : String
    @State private var weight : String
    @State private var height : String
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showError = false
    @Environment(\.dismiss) private var dismiss
    
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Physical Stats") {
                    
                    TextField("Age", text: $age)
                        .limitDecimals($age, decimalLimit: 0, prefix: 3)
                        .keyboardType(.numberPad)
                    TextField("Weight (kg)", text: $weight)
                        .limitDecimals($weight, decimalLimit: 1, prefix: 4)
                        .keyboardType(.decimalPad)
                    TextField("Height (cm)", text: $height)
                        .limitDecimals($height, decimalLimit: 1, prefix: 4)
                        .keyboardType(.decimalPad)
                    
                }
                
                
                Section("Lifestyle") {
                    
                    Picker("Lifestyle", selection: $person.activityLevel) {
                        
                        ForEach (Person.ActivityLevel.allCases, id: \.self) { activityLevel in
                            Text(activityLevel.rawValue)
                        }
                        
                    }
                }
                
            }
            .toolbar {
                ToolbarItem {
                    Button("Save", systemImage: "checkmark.circle") {
                        print(person.weight)
                        savePersonDetails()
                        
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
    
    func savePersonDetails() {
        
        
        guard let validAge = isValidAge()
        else
        
        {
            inputError(title: "Invalid Age", message: "Please enter a valid age")
            age = ""
            return
        }
        guard let validWeight = isValidWeight() else {
            inputError(title: "Invalid weight", message: "Please enter a valid weight ")
            weight = ""
            return
        }
        guard let validHeight = isValidHeight() else {
            inputError(title: "Invalid height", message: "Please enter a valid height ")
            height = ""
            return }
        
        person.age = validAge
        person.weight = validWeight
        person.height = validHeight
        dismiss()
    }
    
    func isValidAge() -> Int? {
        
        guard let age = Int(age), age > 0, age <= 150 else { return nil}
        return age
    }
    
    
//  Unwraps and checks the range
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
    
    init(person: Person) {
        self.person = person
        _age = .init(initialValue: String(person.age))
        _weight = .init(initialValue: String(person.weight))
        _height = .init(initialValue: String(person.height))
    }
}

#Preview {

    EditPersonView(person: Person.example)
}
