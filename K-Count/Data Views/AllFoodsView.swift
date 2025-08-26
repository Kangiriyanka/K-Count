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
    @State private var selectedSortOption: SortOption = .nameAscending
    
    enum SortOption: CaseIterable {
        case nameAscending, nameDescending, caloriesAscending, caloriesDescending
        
        var displayName: String {
            switch self {
            case .nameAscending:
                return "Name A-Z"
            case .nameDescending:
                return "Name Z-A"
            case .caloriesAscending:
                return "Calories Low-High"
            case .caloriesDescending:
                return "Calories High-Low"
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
                            Text(food.name)
                            Spacer()
                            Text("\(String(format: "%0.1f", food.calories)) ")
                             
                                .fontWeight(.medium)
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
            
        }
        
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                
                Menu {
                    Picker("Sort", selection: $selectedSortOption) {
                        ForEach(SortOption.allCases, id: \.self) { option in
                            Label(option.displayName, systemImage: option.systemImage)
                                .tag(option)
                        }
                    }
                    
                    Divider()
                    
                    Button("Delete All Foods", systemImage: "trash", role: .destructive) {
                        isPresentingConfirm = true
                    }
                    
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        
        .confirmationDialog("Delete All Foods",
                            isPresented: $isPresentingConfirm) {
            Button("Would you like to clear all foods?", role: .destructive) {
                clearFoods()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This will permanently delete all your food entries. This action cannot be undone.")
        }
    }
    
    func clearFoods() {
        do {
            try modelContext.delete(model: Food.self)
        } catch {
            print("Failed to delete foods: \(error)")
        }
    }
}

#Preview {
    AllFoodsView()
        .modelContainer(Food.previewContainer())
}
