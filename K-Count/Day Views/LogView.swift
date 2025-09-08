//
//  DaysView.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/10.
//

import SwiftUI
import SwiftData

struct LogView: View {
    
    
    @Environment(\.modelContext) var modelContext
   
 
    @State private var selectedDate: Date
    @State private var matchingDay: Day?
    @State private var showingPopover  = false
    @Query var days : [Day]
    
    
    private var calendar: Calendar
    private var currentDay: Day {
        matchingDay ?? Day.emptyDay
    }
    
    
    var body: some View {
        
    
        NavigationStack {
            
        
            DayView(day: currentDay)
                .onAppear(perform: findMatchingDay)
                .onChange(of: selectedDate) {findMatchingDay()}
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Pick a date", systemImage: "calendar") {
                            
                            showingPopover = true
                        }
                        .popover(isPresented: $showingPopover,  content : {
                            
                            // Pass the selectedDate as a Binding
                            CustomDatePickerView(selectedDate: $selectedDate)
                            
                                .frame(minWidth:350, maxHeight:400)
                                .presentationCompactAdaptation(.popover)
                            
                        })}
                    
                }
            
        }
    }
    
    
    /// Finds a matching `Day` for the current `selectedDate`.
    /// - If a `Day` with the same date exists in `days`, it sets `matchingDay` to that instance.
    /// - If no match exists, it calls `addDay(_:)` to create and add a new `Day` for the `selectedDate`.
    private func findMatchingDay() {
        if let match = days.first(where: { $0.date == selectedDate }) {
            matchingDay = match
        } else {
            addDay(selectedDate)
        }
    }
    
    
    /// Creates and inserts a new `Day` object for the given date.
        ///
        /// - Parameter newDate: The date to create a `Day` for.
        /// - Note: If a `Day` with the same normalized date already exists, no new day will be added.
    private func addDay(_ newDate: Date ) {
        guard let normalizedDate = normalizedDate(from: newDate) else {
            return
        }
        
        if !days.contains(where: {$0.date == normalizedDate}) {
            
            let newDay = Day(date: newDate, weight: 0.0, foodEntries: [])
            modelContext.insert(newDay)
            matchingDay = newDay
        }
    }
    
    // The normalized date only contains the year, month and day. The time is excluded.
    private func normalizedDate(from date: Date) -> Date? {
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        return calendar.date(from: components)
    }
    
    // Initialize the calendar to be set to today's date
    init() {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        
        do {
            guard let normalizedDate = calendar.date(from: components) else {
                throw DateError.invalidRange
            }
            self.selectedDate = normalizedDate
        } catch {
            print("Error creating normalized date:", error.localizedDescription)
            self.selectedDate = Date()
        }
        
        self.calendar = calendar
    }
    
    
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Day.self, configurations: config)
    container.mainContext.insert(Day.example)
    return LogView()
        .modelContainer(container)
     
    
}
