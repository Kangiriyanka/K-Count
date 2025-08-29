//
//  ExportFoodView.swift
//  K-Count
//
//  Created by Kangiriyanka The Single Leaf on 2025/08/28.
//

import SwiftUI

struct ExportFoodsView: View {
    
    @State private var exportFileURL: URL?
    @State private var foods: [Food]
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
                exportFoods(format: selectedFormat, foods)
            }
            .onAppear {
                exportFoods(format: selectedFormat, foods)
            }
            
            
            if let exportFileURL {
                ShareLink(item: exportFileURL ) {
                    Label("Save", systemImage: "square.and.arrow.up")
                }
              
                 
             
            }
               
           
            
        }
        .padding()
 

        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.accent, lineWidth: 0.5)
        )
       
    }
    
    init(foods: [Food]) {
        self.foods = foods
      }
    
    
    func exportFoods(format: ExportFormat, _ foods: [Food]) -> Void {
     let fileManager = FileManager.default
   

     switch format {
         
         case .csv:
         
         var csvString = "Name, Calories, Serving Type\n"
         for food in foods {
          
                 let row = "\(food.name),\(food.calories),\(food.servingType)\n"
                 csvString.append(row)
             }
         
         
         do {
             if let URL = try fileManager.saveCSVFile(csvString: csvString,filename: "foods.csv") {
                 exportFileURL = URL
             }
         }
             catch {
                 
                 errorMessage = error.localizedDescription
                 showError = true
                 
        }
         
         
             
     case .json:
  
        
         
         do {
             let url = try fileManager.saveJSONFile(object: foods, file: "foods")
             exportFileURL = url
         } catch {
             errorMessage = "Failed to create JSON file: \(error.localizedDescription)"
             showError = true
         }
         

         
     }
    

      
     }
    
    
    
    
}

#Preview {
    ExportFoodsView(foods: [Food.exampleBreakfast, Food.example])
}
