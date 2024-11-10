//
//  EditPersonView.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/10.
//

import SwiftUI

struct EditPersonView: View {
    
    @Bindable var person: Person
    
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Physical Stats") {
            
                    TextField("Age", value: $person.age, formatter: NumberFormatter())
                    TextField("Weight (kg)", value: $person.weight, formatter: NumberFormatter())
                    
                    TextField("Height (cm)", value: $person.height, formatter: NumberFormatter())
                    
                }
                
                Section("Lifestyle") {
                    
                    Picker("Lifestyle", selection: $person.activityLevel) {
                        
                        ForEach (Person.ActivityLevel.allCases, id: \.self) { activityLevel in
                            Text(activityLevel.rawValue)
                        }
                        
                    }
                }
                
            }
            .navigationTitle("User Information")
        }
        
    }
}

#Preview {

    EditPersonView(person: Person.example)
}
