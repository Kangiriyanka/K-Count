//
//  KanfitApp.swift
//  Kanfit
//∫
//  Created by Kangiriyanka The Single Leaf on 2024/11/10.
//

import SwiftUI
import SwiftData

@main
struct KanfitApp: App {
   
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Day.self)
        
    }
    
        
}
