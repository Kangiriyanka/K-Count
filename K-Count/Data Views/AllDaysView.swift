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
    @State private var selectedSortOption: SortOption = .date
    @State private var sortOrder: SortOrder = .descending
    @Query var days: [Day]
    
    enum SortOrder {
        case ascending, descending
    }
    
    enum SortOption {
        case date, weight
    }
    
    // Filter and sort days
    var filteredDays: [Day] {
        let filtered = searchText.isEmpty
            ? days.filter { $0.weight > 0.0 }
            : days.filter { $0.weight > 0.0 && $0.formattedDate.localizedCaseInsensitiveContains(searchText) }
        
        switch selectedSortOption {
        case .weight:
            return sortOrder == .descending
                ? filtered.sorted { $0.weight > $1.weight }
                : filtered.sorted { $0.weight < $1.weight }
        case .date:
            return sortOrder == .descending
                ? filtered.sorted { $0.date > $1.date }
                : filtered.sorted { $0.date < $1.date }
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
                .onDelete(perform: deleteDayPermanently)
            }
            .navigationTitle("All Days")
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Section("Sort By") {
                            Picker("Sort Option", selection: $selectedSortOption) {
                                Label("Date", systemImage: "calendar")
                                    .tag(SortOption.date)
                                Label("Weight", systemImage: "scalemass")
                                    .tag(SortOption.weight)
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
