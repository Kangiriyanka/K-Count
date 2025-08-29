//
//  AllDaysView.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/12/13.
//

import SwiftUI
import SwiftData



struct AllDaysView: View {
    
    @Environment(\.modelContext) var modelContext
    @AppStorage("userSettings") var userSettings = UserSettings()
    @State private var isPresentingConfirm: Bool = false
    @State private var searchText = ""
    @State private var isExporting: Bool = false
    @State private var selectedSortOption: SortOption = .dateDescending
 
  
    
    @Query var days: [Day]
    
    enum SortOption: CaseIterable {
        case dateAscending, dateDescending, weightAscending, weightDescending
        
        var displayName: String {
            switch self {
            case .dateAscending:
                return "Oldest First"
            case .dateDescending:
                return "Newest First"
            case .weightAscending:
                return "Highest First"
            case .weightDescending:
                return "Lowest First"
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
    
    var nonEmptyDays: [Day]  {
        return days.filter { $0.weight > 0.0 }
    }
    
    var body: some View {
        NavigationStack {
            
            List {
                
                if filteredDays.isEmpty {
                    ContentUnavailableView {
                        Label("No foods added", systemImage: "basket")
                    } description: {
                        Text("Add foods and come back to see your inventory")
                    }
                } else {
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
                                    
                                        .foregroundColor(.secondary)
                                }
                            }
                            .contentShape(Rectangle())
                            .overlay(
                                NavigationLink(destination: EditDayDataView(day: day)) {
                                    EmptyView()
                                }
                                    .opacity(0)
                            )
                        }
                        
                    }
                }
            }
            
         
                   
            .navigationTitle("All Days")
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            
            
            .sheet(isPresented: $isExporting) {
                

                    ExportDaysView(days: nonEmptyDays)
                        .presentationDetents([.fraction(0.25)])
            
                
        
            }
          
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    
             
                    
             
                        
               
                    
                 
                    // Menus and sub-menus for sorting the days
                    
                    Menu {
                               Menu {
                                   ForEach([SortOption.dateDescending, SortOption.dateAscending], id: \.self) { option in
                                       Button(action: { selectedSortOption = option }) {
                                           if (selectedSortOption == option) {
                                               
                                               HStack {
                                                   Text(option.displayName)
                                                   Image(systemName: "checkmark")
                                               }
                                       
                                           }
                                           else {
                                               Text(option.displayName)
                                           }
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
                                           
                                           if (selectedSortOption == option) {
                                               
                                               HStack {
                                                   Text(option.displayName)
                                                   Image(systemName: "checkmark")
                                               }
                                       
                                           }
                                           else {
                                               Text(option.displayName)
                                           }
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
                    
                    HStack {
                        Button {
                            isExporting.toggle()
                        } label: {
                            Label("", systemImage: "square.and.arrow.up")
                                .labelStyle(.iconOnly)
                        }
                   
  
                    }
                    }
                
            }
          
        }
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
