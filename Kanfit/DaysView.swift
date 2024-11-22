//
//  DaysView.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/10.
//

import SwiftUI
import SwiftData

struct DaysView: View {
    
    @Environment(\.modelContext) var modelContext
    @Query var days : [Day]
    @State private var selectedDate: Date
    @State private var showingPopover  = false
    @State private var matchingDay: Day?
    @State private var insertInitial = false
    @State private var debug = true
    private var calendar: Calendar
    
    
    
   
    
    
    
    var body: some View {
        NavigationStack {
         
            
            DayView(day: matchingDay ?? Day.example, person: Person.example)
            
   
            
           
        
            .onAppear {
                
                if debug {
                    deleteDays()
                }
                
                if days.first(where: { $0.date == selectedDate }) == nil {
                                    addDay(selectedDate)
                                } else {
                                    matchingDay = days.first(where: { $0.date == selectedDate })
                                }
               
            }
            .onChange(of: selectedDate) {
                
                if days.first(where: {$0.date == selectedDate}) != nil {
                    print("This date already exists")
                    matchingDay = days.first(where: { $0.date == selectedDate })
                    
                }
                
                else {
                    
                    addDay(selectedDate)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Pick a date ", systemImage: "calendar") {
                        
                        showingPopover = true
                    }
                    .popover(isPresented: $showingPopover,  content : {
                        
                        // Pass the selectedDate as a Binding
                        CustomDatePickerView(selectedDate: $selectedDate)
                            
                            .frame(minWidth:300, maxHeight:400)
                            .presentationCompactAdaptation(.popover)
                           
                           
                        
                        
                    })
                    
                    
                    
                }
                
                
            }
            
        }
        
        
    }
       
    
    func addDay(_ newDate: Date ) {
      
        
        let components = calendar.dateComponents([.year, .month, .day], from: newDate)
        
        let dateOnly = calendar.date(from: components)!
        
       
        
        if !days.contains(where: {$0.date == dateOnly}) {
                            
            let newDay = Day(date: newDate, foodsEaten: [:], weight: 0)
                            modelContext.insert(newDay)
            matchingDay = newDay
                        }
               
        
        }
    func deleteDays() {
        do {
            try modelContext.delete(model: Day.self)
        } catch {
            print("Failed to delete days.")
        }
    }
    
    init() {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        let dateOnly = calendar.date(from: components)!
        self.calendar = calendar
        self.selectedDate = dateOnly
        
        
        
    }

    

            
        
    }
                             


#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Day.self, configurations: config)
    container.mainContext.insert(Day.example)
    return DaysView()
        .modelContainer(container)
    
}
