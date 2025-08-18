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
    @State private var isPresentingConfirm: Bool = false
    @State private var searchText = ""
    @State private var selectedSortOption: SortOption = .date
    @Query var days : [Day]
    
    enum SortOrder {
        case ascending, descending
    }
    enum SortOption {
        case date, weight
    }
    
    // Weed out the days created, but have an empty weight
    // Filter according to weight and date
    var filteredDays: [Day] {
        
        let filtered = searchText.isEmpty
        ? days.filter { $0.weight > 0.0}
        : days.filter { $0.formattedDate.localizedCaseInsensitiveContains(searchText) }
        
        switch selectedSortOption {
        case .weight:
            return filtered.sorted{ $0.weight > $1.weight }
        case .date:
                                                                                
            return filtered.sorted {$0.date > $1.date}
        }
        
        
        }
         
                                                                             
                                                                             
                                                                             
   
    
    
    var body: some View {
        NavigationStack {
            
            List {
                ForEach(filteredDays) { day in
                    HStack {
                        Text("\(day.formattedDate)")
                        Spacer()
                        Text("\(day.formattedWeight)")
                        
                    }
                    .overlay(
                        
                        NavigationLink(destination: EditDayWeightView(day: day)) {}
                            .opacity(0)
                    )
                }
                .onDelete(perform: deleteDayPermanently)
            }
           
            
            .navigationTitle("All Days")
            .searchable(text: $searchText , placement: .navigationBarDrawer(displayMode: .always))
            .toolbar {
                
                Button("Clear Days",   systemImage: "trash", role: .destructive) {
                    isPresentingConfirm = true
                }
                .confirmationDialog("Are you sure?",
                                    isPresented: $isPresentingConfirm) {
                    Button("Would you like to clear all days?", role: .destructive) {
                        clearDays()
                    }
                }
                
                Menu("Sort", systemImage: "arrow.up.arrow.down") {
                    Picker("Sort", selection: $selectedSortOption) {
                        Text("Sort by Date").tag(SortOption.date)
                        Text("Sort by Weight").tag(SortOption.weight)
                    }
                }
                
            }
            
        }
    }
    
    
    func deleteDayPermanently(offsets: IndexSet) {
      
            for i in offsets {
                   let day = days[i]
                   modelContext.delete(day)
               }
      
    }
    func clearDays() {
     
            do {
                try modelContext.delete(model: Day.self)
            } catch {
                fatalError("Failed to delete days.")
            }
        }
        

}

#Preview {
    
    AllDaysView()
    
    
}
