//
//  SwiftUIView.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/10.
//

import SwiftUI

struct PersonView: View {
    
    let person: Person
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                
                
                Text("Weight: \(String(format: "%0.1f", person.weight)) kg")
                Text("Maintenance calories: \(String(format: "%0.f", person.TDEE))")
                
            }
            
            
            
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    
                        NavigationLink(destination: EditPersonView(person: person)) {
                            Image(systemName: "pencil")
                        }
                        
                        }
                    }
            .navigationBarTitle(person.name, displayMode: .automatic)
            }
         
            
        }
        
       
    
    
    
    
}

#Preview {
    
    PersonView(person: Person.example)
}
