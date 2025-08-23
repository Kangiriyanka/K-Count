//
//  AllFoods.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/12/05.
//

import SwiftUI
import SwiftData

struct AllFoodsView: View {
    
    @Environment(\.modelContext) var modelContext
    @State private var isPresentingConfirm: Bool = false
    @State private var searchText = ""
    @Query var existingFoods: [Food]
    @State private var selectedSortOption: SortOption = .name
    
    enum SortOrder {
        case ascending, descending
    }
    enum SortOption {
        case name, calories
    }
    
    var filteredFoods: [Food] {
        
        let filtered = searchText.isEmpty
                ? existingFoods
                : existingFoods.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        switch selectedSortOption {
        case .name:
            return filtered.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case .calories:
            return filtered.sorted {$0.calories > $1.calories}
        }
        
        
        }
   
    var body: some View {
        NavigationStack {
            
            
            List {
                
                if filteredFoods.isEmpty {
                    ContentUnavailableView {
                        Label("No foods added", systemImage: "basket")
                    } description: {
                        Text("Add foods and come back to see your inventory")
                    }
                }
                else {
                    
                    ForEach(filteredFoods, id: \.self) { food in
                        HStack {
                            Text(food.name)
                            Spacer()
                            Text("\(String(format: "%0.1f", food.calories)) ").foregroundStyle(.secondary)
                        }
                    }

                }
            }
            
            .navigationTitle("All Foods")
            .searchable(text: $searchText , placement: .navigationBarDrawer(displayMode: .always))
            
        }

      
        .toolbar {
            
            Button("Clear Foods",   systemImage: "trash", role: .destructive) {
                isPresentingConfirm = true
            }
            .confirmationDialog("Are you sure?",
                                isPresented: $isPresentingConfirm) {
                Button("Would you like to clear all foods?", role: .destructive) {

                }
            }
            
            Menu("Sort", systemImage: "arrow.up.arrow.down") {
                Picker("Sort", selection: $selectedSortOption) {
                    Text("Sort by Name").tag(SortOption.name)
                    Text("Sort by Calories").tag(SortOption.calories)
                }
            }
        }
    }
    
    
 

    


    
}
        
    


