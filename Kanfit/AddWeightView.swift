//
//  AddWeightView.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/14.
//

import SwiftUI



struct AddWeightView: View {
    
    @State private var dayWeight: Double
    @State private var rawWeightInput: String
    @State private var showingError = false
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @FocusState private var isWeightFocused: Bool
    @State private var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesSignificantDigits = true
        formatter.maximumIntegerDigits = 3
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 0
        
      
        return formatter
    }()
    var day: Day
    let person: Person
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
          
             
                Form {
                    HStack {
                        Text("Weight")
                        
                        
                        TextField("Weight", text: $rawWeightInput)
                            .multilineTextAlignment(.trailing)
                            .focused($isWeightFocused).onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    isWeightFocused = true
                                }
                            }
                    
                            .keyboardType(.decimalPad)
                            .limitDecimals($rawWeightInput, decimalLimit: 1)
                           
                          
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
                    Button("Save", systemImage: "checkmark.circle.fill") {
                        updateWeight()
                        
                        
                        
                        
                        
                    }
                    
                }
            }
            
        }


        func validWeight(weight: Double) -> Bool {
            if weight > 700.0 || weight < 30.0 {
                return false
                
            }
            return true
            
        }
    
        
        func updateWeight() {
            guard validWeight(weight: Double(rawWeightInput) ?? 0) else {
                let title = "Invalid Weight"
                let message = "Please enter a valid weight"
                alertError(title: title, message: message)
                return
            }
            day.weight = Double(rawWeightInput) ?? 0
            dismiss()
        }
    
        func alertError(title: String, message: String) {
            errorTitle = title
            errorMessage = message
            showingError = true
        }
    
        init(day: Day , person: Person) {
              self.person = person
              self.day = day
              self.rawWeightInput = String(self.day.weight)
              _dayWeight = State(initialValue: person.weight)
          }
        
      
    

    
    
  
    }



