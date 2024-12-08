//
//  EditWeightView.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/14.
//

import SwiftUI



struct EditWeightView: View {
    
    var day: Day
    var person: Person
    
    
    @State private var dayWeight: String
    @State private var showingError = false
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @FocusState private var isWeightFocused: Bool
    @Environment(\.dismiss) private var dismiss
    
    
    
    var body: some View {
        NavigationStack {
            
            
            Form {
                HStack {
                    Text("Weight")
                    
                    
                    TextField("Weight", text: $dayWeight)
                        .multilineTextAlignment(.trailing)
                        .focused($isWeightFocused).onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                isWeightFocused = true
                            }
                        }
                    
                        .keyboardType(.decimalPad)
                        .limitDecimals($dayWeight, decimalLimit: 1, prefix: 3)
                    
                    
                    Text("kg")
                    
                    
                }
                
                
                
            }
            
            
            .navigationTitle("Add Weight")
            .navigationBarTitleDisplayMode(.inline)
            .scrollDismissesKeyboard(.interactively)
            .alert(errorTitle, isPresented: $showingError) { } message: {
                Text(errorMessage)
                
                
            }
            .toolbar {
                ToolbarItem {
                    Button("Save", systemImage: "checkmark.circle") {
                        validateWeight()
                        
                    }
                    
 
                }
                
            }
        }
        
    }
    
   
    
    
    func validateWeight() {
        guard let validWeight = isValidWeight()  else {
         
            inputError (title: "Invalid weight", message: "Please enter a valid weight")
            return
        }
       
     
       
        updatePersonWeight(weight: validWeight)
        dismiss()
    }
    
    // If the weight was updated today, change the person's weight
    func updatePersonWeight(weight: Double) {
        
        day.weight = weight
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyy"
        let today = formatter.string(from: Date.now)
        
        if day.formattedDate == today {
            person.weight = day.weight
        }
    }
    
    
    func isValidWeight() -> Double? {
        guard let validWeight = Double(dayWeight), validWeight >= 0.0 && validWeight <= 1000.0  else {return nil}
        return validWeight
    }
    
    
    
    func inputError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
    init(day: Day , person: Person) {
        self.person = person
        self.day = day
        self.dayWeight = day.weight == 0.0 ? String(person.weight) : String(day.weight)
       
    }
    
    
    
    
    
    
    
}



