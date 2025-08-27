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
    @State private var selectedSortOption: SortOption = .nameDescending
    
    enum SortOption: CaseIterable {
        case nameAscending, nameDescending, caloriesAscending, caloriesDescending
        
        var displayName: String {
            switch self {
            case .nameAscending:
                return "Name A-Z"
            case .nameDescending:
                return "Name Z-A"
            case .caloriesAscending:
                return "Low Calories"
            case .caloriesDescending:
                return "High Calories"
            }
        }
        
        var systemImage: String {
            switch self {
            case .nameAscending:
                return "textformat.abc"
            case .nameDescending:
                return "textformat.abc"
            case .caloriesAscending:
                return "chart.bar"
            case .caloriesDescending:
                return "chart.bar"
            }
        }
    }
    
    var filteredFoods: [Food] {
        let filtered = searchText.isEmpty
        ? existingFoods
        : existingFoods.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        
        switch selectedSortOption {
        case .nameAscending:
            return filtered.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case .nameDescending:
            return filtered.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedDescending }
        case .caloriesAscending:
            return filtered.sorted { $0.calories < $1.calories }
        case .caloriesDescending:
            return filtered.sorted { $0.calories > $1.calories }
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
                            VStack(alignment:.leading){
                                Text(food.name)
                                Text("per " + food.servingType)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                
                            }
                            
                            Spacer()
                            Text("\(String(format: "%0.1f", food.calories)) ")
                            
                                .foregroundStyle(.secondary)
                        }
                        .contentShape(Rectangle())
                        .overlay(
                            NavigationLink(destination: EditFoodView(food: food)) {
                                EmptyView()
                            }
                                .opacity(0)
                        )
                    }
                    
                }
            }
            
            .navigationTitle("All Foods")
            .searchable(text: $searchText , placement: .navigationBarDrawer(displayMode: .always))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Menu {
                        Menu {
                            ForEach([SortOption.nameDescending, SortOption.nameAscending], id: \.self) { option in
                                Button(action: { selectedSortOption = option }) {
                                    Label(option.displayName, systemImage: selectedSortOption == option ? "checkmark" : "")
                                }
                            }
                        } label: {
                            HStack(spacing:0) {
                                Text("Name")
                                Image(systemName: "calendar")
                            }
                        }
                        
                        
                        Menu {
                            ForEach([SortOption.caloriesDescending, SortOption.caloriesAscending], id: \.self) { option in
                                
                                Button(action: {selectedSortOption = option}) {
                                    Label(option.displayName, systemImage: selectedSortOption == option ? "checkmark" : "")
                                }
                            }
                        } label: {
                            HStack(spacing:0) {
                                Text("Calories")
                                Image(systemName: "fork.knife")
                            }
                        }
                        
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            
        }
        
        
    }
}

#Preview {
    AllFoodsView()
        .modelContainer(Food.previewContainer())
}
