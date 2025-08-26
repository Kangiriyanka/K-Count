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
    @State private var selectedSortOption: SortOption = .dateDescending
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
                return "Weight Low-High"
            case .weightDescending:
                return "Weight High-Low"
            }
        }
        
        var systemImage: String {
            switch self {
            case .dateAscending, .dateDescending:
                return "calendar"
            case .weightAscending, .weightDescending:
                return "scalemass"
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
            .navigationTitle("All Days")
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
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
                        
                        Button("Delete All Days", systemImage: "trash", role: .destructive) {
                            isPresentingConfirm = true
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .confirmationDialog("Delete All Days", isPresented: $isPresentingConfirm, titleVisibility: .visible) {
                Button("Delete All Days", role: .destructive) {
                    clearDays()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This will permanently delete all your weight entries. This action cannot be undone.")
            }
        }
    }
    
    func deleteDayPermanently(offsets: IndexSet) {
        for i in offsets {
            let day = filteredDays[i] // Use filteredDays instead of days
            modelContext.delete(day)
        }
    }
    
    func clearDays() {
        do {
            try modelContext.delete(model: Day.self)
        } catch {
            print("Failed to delete days: \(error)")
        }
    }
}


extension DateFormatter {
    static let dayOfWeek: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }()
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
