//
//  CustomDatePickerView.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/13.
//

import SwiftUI



struct CustomDatePickerView: View {
    
    @Binding var selectedDate: Date
    
    private let yearRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let minDate = calendar.date(byAdding: .year, value: -10, to: .now )

        let maxDate = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: .now))
        
        return minDate!...maxDate!
        
        
    }()
    
    
    var body: some View {
        
       
                DatePicker ("Select Date",
                            selection: $selectedDate,
                            in: yearRange,
                            displayedComponents: [.date]
                            )
                            
              
                .datePickerStyle(GraphicalDatePickerStyle())
                    
                
            }
        }
   
    
