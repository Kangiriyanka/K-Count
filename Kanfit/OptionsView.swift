//
//  OptionsView.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/28.
//

import SwiftUI
import SwiftData



struct OptionsView: View {
    
    @Query(sort: \Day.date, order: .reverse) var days : [Day]
    
    @State private var exportFileURL: URL? = nil

    var body: some View {
        NavigationStack {
            
            VStack(alignment: .leading) { 
            
           Text("Export Data")
            
            
                Button("Export")  {
                    exportDays(days)
                
                }
                
                if let url = exportFileURL {
                    ShareLink(item: url) {
                        Label("Share CSV File", systemImage: "square.and.arrow.up")
                    }
                }
                
                
                NavigationLink("See all foods",destination: AllFoodsView())
                
              
            }
            }
    }
    
    func exportDays(_ days: [Day]) -> Void {
        
        let fileManager = FileManager.default
        var csvString = "Date,Weight (kg),Total Calories, Food Log\n"
        
        for day in days {
            
            if day.weight != 0 {
                let row = "\(day.csvDate),\(day.weight),\(day.totalCalories), \(day.foodsEatentoCSV)\n"
                csvString.append(row)
            }
        }
        if let URL = fileManager.saveCSVFile(csvString: csvString) {
            
            print("Successfully saved file to  \(URL)")
            exportFileURL = URL
        }
       
    }
    
    
    
    
 
      
    }


#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Day.self, configurations: config)
    container.mainContext.insert(Day.example)
    return OptionsView()
        .modelContainer(container)
}
