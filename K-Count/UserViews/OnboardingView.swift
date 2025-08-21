//
//  OnboardingView.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2025/07/06.
//

import SwiftUI


// ---- Enums for Height/Weight Conversions  ---- //
// For the Picker
enum MeasurementSystem: String, CaseIterable {
    case metric = "Metric"
    case imperial = "Imperial"
    
}

// Enum for conversions
enum HeightValue: Equatable{
    case metric(Double)
    case imperial(FootInches)
    
    struct FootInches: Equatable {
        let foot: Int
        let inches: Int
    }
    

    var asCentimeters: Double {
        switch self {
        case .metric(let value): return value
        case .imperial(let fi): return (Double(fi.foot) * 30.48) + (Double(fi.inches) * 2.54)
        }
    }
    
    var asFeetInches: FootInches {
        switch self {
        case .imperial(let fi): return fi
        case .metric(let value):
            let totalInches = value / 2.54
            let f = Int(totalInches) / 12
            let i = Int(totalInches) % 12
            return FootInches(foot: f, inches: i)
        }
    }
    
    
}

enum WeightValue {
    case metric(Double)
    case imperial(Double)
    
    var asKilograms: Double {
        switch self {
        case .metric(let value): return value
        case .imperial(let value): return value * 2.20462
        }
    }
    
    var asPounds: Double {
        switch self {
        case .imperial(let value): return value
        case .metric(let value): return value / 2.20462
        }
    }
}

// ---- Onboarding View ---- //

struct OnboardingView: View {
    
    @AppStorage("userSettings") var userSettings = UserSettings()
    @AppStorage("hasOnboarded") var hasOnboarded: Bool = false
    
    @State private var name: String = ""
    @State private var height: HeightValue = .metric(170)
    @State private var weight: Double = 0
    @State private var birthday: Date = Calendar.current.date(byAdding: .year, value: -20, to: Date()) ?? Date()
    @State private var age: String = ""
    @State private var sexAssigned: UserSettings.Sex = .male
    @State private var activityLevel: UserSettings.ActivityLevel = .sedentary
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showError = false
    @State private var showWeight = false
    @State private var showHeight = false
    @State private var measurementPreference: MeasurementSystem = .metric
    @State private var feet: Int = 0
    @State private var inches: Int = 0
    
    
    
    var body: some View {
        NavigationStack {
            
            
          
            
            
            Form {
                
                Text("Welcome to K-Count!")
                .font(.title).bold()
                .listRowBackground(Color.clear)
                
                
                
                
                Section("What's your name?") {
                    
                    
                    HStack {
                        Text("Name")
                        TextField("Name", text: $name)
                            .keyboardType(.default)
                            .multilineTextAlignment(.trailing)
                    }
                    
                 
                }
                
                Section("Your details") {
                    HStack {
                        
                        Text("Birthday")
                        DatePicker("", selection: $birthday, displayedComponents: .date)
                            .datePickerStyle(.compact)
                    }
                    
                    HStack {
                        Text("Height")
                        Spacer()
                      
                        
                      
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .onTapGesture {
                        showHeight.toggle()
                    }
                    .sheet(isPresented: $showHeight) {
                        CustomHeightPicker(preference: $measurementPreference, height: $height)
                                    .presentationDetents([.fraction(0.35)])
                            }
                 
                  
                    
                    HStack {
                        Text("Weight")
                        Spacer()
                        Text(weight == 0 ? "Tap to select weight" : String(format: "%.1f", weight) )
                        
                     
                    }
                    .onTapGesture {
                        showWeight.toggle()
                    }
                    .sheet(isPresented: $showWeight) {
                        CustomWeightPicker(weight: $weight)
                                    .presentationDetents([.fraction(0.25)])
                            }
                    
                    
                
                
                
                    Picker("Sex assigned at birth", selection: $sexAssigned) {
                        
                        ForEach (UserSettings.Sex.allCases, id: \.self) { sex in
                            Text(sex.rawValue)
                                .tag(sex)
                        }
                        
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
                            userSettings.height = height.asCentimeters
                            userSettings.weight = weight
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
    
      
        
        return true
        
        
     }
        
    
    
    
    
    func isValidAge() -> Int? {
        
        guard let age = Int(age), age > 0, age <= 150 else { return nil}
        return age
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
