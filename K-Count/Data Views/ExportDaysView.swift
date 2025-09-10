//
//  SwiftUIView.swift
//  K-Count
//
//  Created by Kangiriyanka The Single Leaf on 2025/08/27.
//

import SwiftUI

enum ExportFormat: String, CaseIterable {
    case csv
    case json
}


struct ExportDaysView: View {
    
    @State private var exportFileURL: URL?
    @State private var days: [Day]
    @State private var selectedFormat: ExportFormat = .csv
    @State private var errorMessage = ""
    @State private var showError = false
    @AppStorage("userSettings") var userSettings = UserSettings()
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Exporting days ").fontWeight(.semibold).underline()
            HStack(spacing:0){
                Text("Select a format:")
                Picker("Format", selection: $selectedFormat) {
                    ForEach(ExportFormat.allCases, id: \.self) { format in
                        Text(format.rawValue)
                            .tag(format)
                    }
                }
                
                .onChange(of: selectedFormat) { _, _ in
                    exportDays(format: selectedFormat, days)
                }
                .onAppear {
                    exportDays(format: selectedFormat, days)
                }
            }
            
         
            
            if let exportFileURL {
                ShareLink(item: exportFileURL ) {
                    Text("Save").fontWeight(.bold)
                }
                
               
                 
             
            }
               
           
            
        }
        .padding()
 
        .frame(width: 300)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.accent.opacity(0.05)) 
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.accent, lineWidth: 0.5)
        )

     
      
        
    }
    
    
    init(days: [Day]) {
        self.days = days
      }
    
    
    func exportDays(format: ExportFormat, _ days: [Day]) -> Void {
     let fileManager = FileManager.default
      
   
        let exportDays = days.filter {$0.weight != 0}
     switch format {
         case .csv:
         
         var csvString = "Date,Weight,Total Calories, Food Log\n"
         for day in exportDays {
             
             var csvWeight: String {
                 let dayWeight = WeightValue.metric(day.weight)
                 if userSettings.weightPreference == .metric {
                     return dayWeight.kilogramsDescription
                 } else {
                     return dayWeight.poundsDescription
                 }
             }
             
             
             let row = "\(day.csvDate),\(csvWeight),\(day.totalCalories), \(day.foodsEatentoCSV)\n"
                 csvString.append(row)
             
         }
         
         do {
             if let URL = try fileManager.saveCSVFile(csvString: csvString, filename: "days.csv") {
                 exportFileURL = URL
             }
         }
             catch {
                 
                 errorMessage = error.localizedDescription
                 showError = true
                 
             }
         
         
             
     case .json:
       
         
         do {
             let url = try fileManager.saveJSONFile(object: exportDays, filename: "days.json")
             exportFileURL = url
         } catch {
             errorMessage = "Failed to create JSON file: \(error.localizedDescription)"
             showError = true
         }
         

         
     }
    

      
     }
    }





    
    
    
  


#Preview {
    ExportDaysView(days: Day.examples)
}
