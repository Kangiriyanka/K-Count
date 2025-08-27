//
//  OptionsView.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/28.
//

import SwiftUI
import SwiftData

struct DataView: View {
    
    @Query(sort: \Day.date, order: .reverse) var days: [Day]
  

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    
                    NavigationLink(destination: AllFoodsView()) {
                        HStack(spacing: 6){
                            Image(systemName: "fork.knife")
                            Text("My Foods")
                        }
                        .dataCardStyle()
                    }
                    
                    NavigationLink(destination: AllDaysView()) {
                        HStack(spacing: 6) {
                            Image(systemName: "list.clipboard")
                            Text("Days Data")
                        }
                        .dataCardStyle()
                    }
                    
                    NavigationLink(destination: UserSettingsView()) {
                        HStack(spacing: 6) {
                            Image(systemName: "person.fill")
                            Text("User Preferences")
                        }
                        .dataCardStyle()
                      
                    }
                }
                .padding(.horizontal)
            }
            .navigationBarTitle("Data", displayMode: .automatic)
        }
    }
    

}

#Preview {
    return DataView().modelContainer(Day.previewContainer())
}
