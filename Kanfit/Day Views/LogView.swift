//
//  DaysView.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/10.
//

import SwiftUI
import SwiftData

//Discussion points: Normalizing the date was required to find the matching day. If I had not normalized the date, the matching day function would have never found matches since the dates are time-sensitive.

// DaysView shows a day based on a date selected in our CustomCalendarView
// modelContext is necessary for creating a day and adding it to our Model data.
// We use the person's TDEE to calculate the remaining calories of the DayView
// This changes based on the person's weight

struct LogView: View {
    
    
    @Environment(\.modelContext) var modelContext
   
    
    private var calendar: Calendar
    @State private var selectedDate: Date
    @State private var matchingDay: Day?
    @State private var showingPopover  = false
    @Query var days : [Day]
    
    
    var body: some View {
        
        // The toolbar contains a Toolbar button that pops a calendar for the user to select a date
        NavigationStack {
            
            
            // Render a day view if a matching day is found.
        
            DayView(day: matchingDay ?? Day.emptyDay)
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
    func findMatchingDay() {
        
        if let match = days.first(where: { $0.date == selectedDate }) {
            matchingDay = match
        } else {
            addDay(selectedDate)
        }
    }
    
    
    // Creates an empty day
  
    func addDay(_ newDate: Date ) {
        
        
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
    func normalizedDate(from date: Date) -> Date? {
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        return calendar.date(from: components)
    }
    
    // Initialize the calendar to be set to today's date
    // The normalized date only contains the year, month and day. The time is excluded.
    init() {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        // A date by default stores time. This removes the time component of the Date.
        guard let normalizedDate = calendar.date(from: components) else {
            fatalError("Unable to create normalized date from current date")
        }
        self.selectedDate = normalizedDate
        self.calendar = calendar
        self.selectedDate = normalizedDate
        
        
    }
    
    
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Day.self, configurations: config)
    container.mainContext.insert(Day.example)
    return LogView()
        .modelContainer(container)
     
    
}
