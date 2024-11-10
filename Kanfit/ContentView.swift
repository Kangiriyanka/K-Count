//
//  ContentView.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/10.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    
 
    
    let person = Person.example
    var body: some View {
        
        TabView {
           
            DaysView()
                .tabItem {
                    Label("Day", systemImage: "clock")
                }
            
            
            PersonView(person: person)
                .tabItem {
                    Label("Me", systemImage: "person")
                }
            
            
            
        }
        
        
    }
    
    

}


#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Day.self, configurations: config)
    container.mainContext.insert(Day.example)
    return ContentView()
        .modelContainer(container)
}
