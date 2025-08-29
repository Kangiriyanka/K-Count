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
    
    var body: some View {
        VStack {
            Text("Select a format").fontWeight(.semibold)
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
            
            
            if let exportFileURL {
                ShareLink(item: exportFileURL ) {
                    Text("Save").fontWeight(.bold)
                }
               
                 
             
            }
               
           
            
        }
        .padding()
 

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
   

     switch format {
         case .csv:
         
         var csvString = "Date,Weight (kg),Total Calories, Food Log\n"
         for day in days {
             if day.weight != 0 {
                 let row = "\(day.csvDate),\(day.weight),\(day.totalCalories), \(day.foodsEatentoCSV)\n"
                 csvString.append(row)
             }
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
         // Filter days with weight > 0
         let exportDays = days.filter { $0.weight != 0 }
         
         do {
             let url = try fileManager.saveJSONFile(object: exportDays, file: "days")
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
