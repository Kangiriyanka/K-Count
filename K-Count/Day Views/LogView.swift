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
    
    
    // Find the matching day based on the selected date
    // If there is no matching day, the addDay function will create a day and add it to the Day model
    private func findMatchingDay() {
        
        if let match = days.first(where: { $0.date == selectedDate }) {
            matchingDay = match
        } else {
            addDay(selectedDate)
        }
    }
    
    
    // Creates a day 
    private func addDay(_ newDate: Date ) {
        guard let normalizedDate = normalizedDate(from: newDate) else {
            print("Error: Unable to normalize date from \(newDate)")
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
    // The normalized date only contains the year, month and day. The time is excluded.
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
