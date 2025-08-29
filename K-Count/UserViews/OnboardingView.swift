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
    @State private var height: HeightValue = .metric(160)
    @State private var weight: WeightValue = .metric(60)
    @State private var goalWeight: WeightValue = .metric(60)
    @State private var birthday: Date = Calendar.current.date(byAdding: .year, value: -18, to: Date()) ?? Date()
    @State private var age: String = ""
    @State private var sexAssigned: UserSettings.Sex = .male
    @State private var activityLevel: UserSettings.ActivityLevel = .sedentary
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showError = false
    @State private var showWeightView = false
    @State private var showGoalWeightView = false
    @State private var showHeightView = false
    @State private var hasPickedHeight = false
    @State private var hasPickedWeight = false
    @State private var heightPreference: MeasurementSystem = .metric
    @State private var weightPreference: MeasurementSystem = .metric
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
                        DatePicker(
                               "",
                               selection: $birthday,
                               in: Calendar.current.date(byAdding: .year, value: -100, to: Date())!...Calendar.current.date(byAdding: .year, value: -16, to: Date())!,
                               displayedComponents: .date
                           )
                           .datePickerStyle(.compact)
                    }
                    
                    HStack {
                        Text("Height")
                        Spacer()
                        
                        if hasPickedHeight {
                            
                            Text(heightPreference == .metric ? height.centimetersDescription :
                                    height.feetInchesDescription)
                        } else {
                            Text("Tap to select height")
                        }
                            
                      
                        
                      
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .onTapGesture {
                        showHeightView.toggle()
                    }
                    .sheet(isPresented: $showHeightView) {
                        CustomHeightPicker(preference: $heightPreference, height: $height)
                                    .presentationDetents([.fraction(0.40)])
                            }
                    .onChange(of: height) { _, newValue in
                        hasPickedHeight = true
                    }
                 
                  
                    
                    HStack {
                        Text("Weight")
                        Spacer()
                        
                        if hasPickedWeight {
                            Text(weightPreference == .metric ? weight.kilogramsDescription :
                                    weight.poundsDescription)
                        } else {
                            Text("Tap to select weight")
                        }
                        
                     
                    }
                    .onTapGesture {
                        showWeightView.toggle()
                    }
                    .sheet(isPresented: $showWeightView) {
                        CustomWeightPicker(preference: $weightPreference, weight: $weight)
                                    .presentationDetents([.fraction(0.40)])
                            }
                    .onChange(of: weight) { _, newValue in
                        hasPickedWeight = true
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
                        
                
                Section("Goal Weight") {
                    
                    
                    HStack {
                        Text("Goal")
                        Spacer()
                        
                        if hasPickedWeight {
                            Text(weightPreference == .metric ? weight.kilogramsDescription :
                                    weight.poundsDescription)
                        } else {
                            Text("Tap to select weight")
                        }
                        
                     
                    }
                    .onTapGesture {
                        showGoalWeightView.toggle()
                    }
                    
                    .sheet(isPresented: $showGoalWeightView) {
                        CustomWeightPicker(preference: $weightPreference, weight: $goalWeight)
                                    .presentationDetents([.fraction(0.40)])
                            }
                    
                 
                }
                    
                    
                    
                    
                    Button("All Set!") {
                      
                        if validateUserDetails() {
                            userSettings.name = name
                            userSettings.birthday = birthday
                            userSettings.height = height.asCentimeters
                            userSettings.weight = weight.asKilograms
                            userSettings.sex = sexAssigned
                            userSettings.activityLevel = activityLevel
                            userSettings.heightPreference = heightPreference
                            userSettings.weightPreference = weightPreference
                            hasOnboarded = true
                        }
                        
                        
                        
                    }
                    .frame(maxWidth: .infinity)
                    .listRowBackground(EmptyView())
                    .buttonStyle(AddButton())
                    .disabled(
                        !hasPickedHeight ||
                        !hasPickedWeight ||
                        name.trimmingCharacters(in: .whitespacesAndNewlines).count < 2
                    )
                }
            
                .alert(errorTitle, isPresented: $showError) {
                    Button("OK") { }
                } message: {
                    Text(errorMessage)
                }
            }
            
        }
    
    

    func validateUserDetails() -> Bool {
        
        if name.count < 2 {
            inputError(title: "Invalid Name", message: "Please enter 2 or more characters")
            return false
        }
        
        if name.count > 30 {
            inputError(title: "Invalid Name", message: "Please enter less than 30 characters")
            return false
        }
        
        
        return true
        
     }
        

    func inputError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showError = true
    }
    
    func isDisabled() -> Bool {
        
        return !hasPickedHeight || !hasPickedWeight || name.trimmingCharacters(in: .whitespacesAndNewlines).count < 3
    }
}

    

#Preview {
    OnboardingView()
    
}
