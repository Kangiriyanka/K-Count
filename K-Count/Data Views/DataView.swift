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
    @AppStorage("userSettings") var userSettings = UserSettings()
  

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
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
                            Text("My Days")
                        }
                        .dataCardStyle()
                    }
                    
                    NavigationLink(destination: ProfileView()) {
                        HStack(spacing: 6) {
                            Image(systemName: "person.fill")
                            Text("My Profile")
                        }
                        .dataCardStyle()
                      
                    }
                }
                .padding()
            }
            .navigationBarTitle("My Data", displayMode: .inline)
        }
    }
    

}

#Preview {
    return DataView().modelContainer(Day.previewContainer())
}
