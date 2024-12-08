//
//  DayViewRow.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/10.
//

import SwiftUI

struct CalculationsRow: View {
    var rowName: String
    var value: String
     
    var body: some View {
        HStack {
            Text(rowName).font(.title3).bold()
            Spacer()
            Text((value))
            
        }
        .listRowBackground(Color.gray.opacity(0.05))
      
    }
}

#Preview {
    CalculationsRow(rowName: "Total Calories:", value: "1234")
}
