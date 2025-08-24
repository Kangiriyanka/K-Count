//
//  OptionsView.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/28.
//

import SwiftUI
import SwiftData

struct DataView: View {
    
    @Query(sort: \Day.date, order: .reverse) var days: [Day]
    @State private var exportFileURL: URL? = nil

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    
                    Button(action: {
                        exportDays(days)
                    }) {
                        VStack {
                            Text("Export CSV")
                            if let url = exportFileURL {
                                ShareLink(item: url) {
                                    Label("Share", systemImage: "square.and.arrow.up")
                                }
                            }
                        }
                        .contentShape(Rectangle())
                        .dataCardStyle()
                    }
                    
                    NavigationLink(destination: AllFoodsView()) {
                        VStack {
                            Text("Foods Data")
                        }
                        .dataCardStyle()
                    }
                    
                    NavigationLink(destination: AllDaysView()) {
                        VStack {
                            Text("Days Data")
                        }
                        .dataCardStyle()
                    }
                    
                    NavigationLink(destination: UserSettingsView()) {
                        VStack {
                            Text("User Settings")
                        }
                        .dataCardStyle()
                      
                    }
                }
                .padding(.horizontal)
            }
            .navigationBarTitle("Data", displayMode: .automatic)
        }
    }
    
    private func exportDays(_ days: [Day]) -> Void {
        let fileManager = FileManager.default
        var csvString = "Date,Weight (kg),Total Calories, Food Log\n"
        
        for day in days {
            if day.weight != 0 {
                let row = "\(day.csvDate),\(day.weight),\(day.totalCalories), \(day.foodsEatentoCSV)\n"
                csvString.append(row)
            }
        }
        
        if let URL = fileManager.saveCSVFile(csvString: csvString) {
            exportFileURL = URL
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Day.self, configurations: config)
    container.mainContext.insert(Day.example)
    return DataView()
        .modelContainer(container)
}
