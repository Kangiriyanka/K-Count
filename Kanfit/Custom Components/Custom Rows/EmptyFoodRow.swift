//
//  EmptyFoodRow.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/14.
//

import SwiftUI

struct EmptyFoodRow: View {
    var body: some View {
        (Text("Press ") + Text(Image(systemName: "fork.knife")) + Text(" to add food"))
            .foregroundStyle(.secondary)
            .bold()
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity)
            .shadow(color: .gray, radius: 0.5, x: 0, y: 0)
            
         
            .overlay( RoundedRectangle(cornerRadius:10)
                .stroke(Color.gray, lineWidth: 1)
                
            )
        .listRowBackground(EmptyView())
        }
    }


#Preview {
    EmptyFoodRow()
}
