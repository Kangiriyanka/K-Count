//
//  AllDaysView.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/12/13.
//

import SwiftUI
import SwiftData

enum ExportFormat: String, CaseIterable {
    case csv
    case json
}

struct AllDaysView: View {
    
    @Environment(\.modelContext) var modelContext
    @AppStorage("userSettings") var userSettings = UserSettings()
    @State private var isPresentingConfirm: Bool = false
    @State private var searchText = ""
    @State private var exportFileURL: URL? = nil
    @State private var isExporting: Bool = false
    @State private var selectedSortOption: SortOption = .dateDescending
    @State private var selectedFormat: ExportFormat = .csv
    @State private var errorMessage: String? = nil
    @State private var showError = false
    
    @Query var days: [Day]
    
    enum SortOption: CaseIterable {
        case dateAscending, dateDescending, weightAscending, weightDescending
        
        var displayName: String {
            switch self {
            case .dateAscending:
                return "Date Oldest First"
            case .dateDescending:
                return "Date Newest First"
            case .weightAscending:
                return "Weight Highest First"
            case .weightDescending:
                return "Weight Lowest First"
            }
        }
        
     
    }
    
    // Filter and sort days
    var filteredDays: [Day] {
        let filtered = searchText.isEmpty
            ? days.filter { $0.weight > 0.0 }
            : days.filter { $0.weight > 0.0 && $0.formattedDate.localizedCaseInsensitiveContains(searchText) }
        
        switch selectedSortOption {
        case .dateAscending:
            return filtered.sorted { $0.date < $1.date }
        case .dateDescending:
            return filtered.sorted { $0.date > $1.date }
        case .weightAscending:
            return filtered.sorted { $0.weight < $1.weight }
        case .weightDescending:
            return filtered.sorted { $0.weight > $1.weight }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredDays) { day in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(day.formattedDate)
                                .font(.body)
                            Text(DateFormatter.dayOfWeek.string(from: day.date))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 2) {
                            let weightValue = WeightValue.metric(day.weight)
                            Text(weightValue.display(for: userSettings.weightPreference))
                                .font(.body)
                                .fontWeight(.medium)
                        }
                    }
                    .contentShape(Rectangle())
                    .overlay(
                        NavigationLink(destination: EditCurrentWeightView(day: day)) {
                            EmptyView()
                        }
                        .opacity(0)
                    )
                }
              
            }
            .alert("Error", isPresented: $showError) {
                       Button("OK", role: .cancel) { }
                   } message: {
                       Text(errorMessage ?? "Unknown error")
                   }
                   
            .navigationTitle("All Days")
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .sheet(isPresented: $isExporting) {
                
                if let url = exportFileURL {
                       ExportView(url: url)
                        .presentationDetents([.fraction(0.20)])
                    
                   }
                
                
                
              
            }
          
            .toolbar {
                ToolbarItemGroup {
                    
             
                    Menu {
                  
                        Picker("Format", selection: $selectedFormat) {
                            ForEach(ExportFormat.allCases, id: \.self) { format in
                                Text(format.rawValue)
                                    .tag(format)
                            }
                        }
                        Divider()
                        Button("Export") {
                            exportDays(format: selectedFormat, filteredDays)
                        }
                        .fontWeight(.bold)
                    } label : {
                        Image(systemName: "square.and.arrow.up")
                            .fontWeight(.medium)
                    }
                    
                 
                        
                    Menu {
                               Menu {
                                   ForEach([SortOption.dateDescending, SortOption.dateAscending], id: \.self) { option in
                                       Button(action: { selectedSortOption = option }) {
                                           Label(option.displayName, systemImage: selectedSortOption == option ? "checkmark" : "")
                                       }
                                   }
                               } label: {
                                   HStack(spacing:0) {
                                       Text("Date")
                                       Image(systemName: "calendar")
                                   }
                               }
                               
                               Menu {
                                   ForEach([SortOption.weightDescending, SortOption.weightAscending], id: \.self) { option in
                                       Button(action: { selectedSortOption = option }) {
                                           Label(option.displayName, systemImage: selectedSortOption == option ? "checkmark" : "")
                                       }
                                   }
                               } label: {
                                   HStack {
                                       Image(systemName: "scalemass")
                                       Text("Weight")
                                       
                                   }
                               }
                               
                          
                           } label: {
                               Image(systemName: "arrow.up.arrow.down")
                           }
                    }
                
            }
          
        }
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
           
           if let URL = fileManager.saveCSVFile(csvString: csvString) {
               exportFileURL = URL
            
           }
           
               
           case .json:
               
               var jsonData: [[String: Any]] = []
               
               for day in days {
                   if day.weight != 0 {
                       var jsonObject: [String: Any] = [:]
                       jsonObject["Date"] = day.csvDate
                       jsonObject["Weight (kg)"] = day.weight
                       jsonObject["Total Calories"] = day.totalCalories
                       jsonObject["Foods Eaten"] = day.foodsEatentoCSV
                       
                       jsonData.append(jsonObject)
                   }
                   
                  
               }
           
         
           
           
           
           
           
           
           
           
       }
      
        isExporting = true
        
       }


    
}



#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Day.self, configurations: config)
    
    // Insert multiple examples
    for day in Day.examples {
        container.mainContext.insert(day)
    }
    
    return AllDaysView()
        .modelContainer(container)
}
