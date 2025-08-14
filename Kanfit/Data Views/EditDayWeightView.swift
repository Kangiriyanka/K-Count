//
//  EditDayWeightView.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2025/07/06.
//

import SwiftUI

struct EditDayWeightView: View {
    
    var day: Day
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
                
                
                
                
                
                
                .navigationTitle("Edit Day Weight")
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
    }
    
    
    
    func validateWeight() {
        guard let validWeight = isValidWeight()  else {
            inputError (title: "Invalid weight", message: "Please enter a valid weight")
            return
        }
       
     
       
        updateDayWeight(weight: validWeight)
        dismiss()
    }
    
    func updateDayWeight(weight: Double) {
        
        day.weight = weight
        
        

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
    
    init(day: Day) {
        self.day = day
        self.dayWeight = String(day.weight)
        
    }
}





#Preview {
    let day = Day.example
    EditDayWeightView(day: Day.example)
}
