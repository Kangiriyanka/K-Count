//
//  KanfitApp.swift
//  Kanfit
//∫
//  Created by Kangiriyanka The Single Leaf on 2024/11/10.
//

import SwiftUI
import SwiftData


struct RootView: View {
    @AppStorage("hasOnboarded") var hasOnboarded: Bool = false
    
    
    var body: some View {
        ZStack {
            if hasOnboarded {
                ContentView()
                  
            } else {
                OnboardingView()
                    .transition(.move(edge: .leading).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.5), value: hasOnboarded)
    }
}

@main
struct KCountApp: App {
    #if DEBUG
    let container = try! ModelContainer(for: Day.self, Food.self, FoodEntry.self)
    #endif
    var body: some Scene {
        
        WindowGroup {
            RootView()
                .onAppear {
                                  #if DEBUG
                                  generateSampleDays()
                                  #endif
                              }
        }
        .modelContainer(for: [Day.self, Food.self, FoodEntry.self])
    }
    
    #if DEBUG
    private func generateSampleDays() {
            let context = ModelContext(container)
            
            // Check if days already exist
            let descriptor = FetchDescriptor<Day>()
            let existingDays = (try? context.fetch(descriptor)) ?? []
            
            guard existingDays.isEmpty else { return }
            
            let days = Day.generateExamples(count: 365)
            for day in days {
                context.insert(day)  // Use insert, not add
            }
            
            try? context.save()
   
        }
    #endif
    
}

#Preview("Onboarded") {
    RootView()
        .modelContainer(for: [Day.self, Food.self, FoodEntry.self], inMemory: true)
    
}

#Preview("Not Onboarded") {
    
    RootView(hasOnboarded: false)
    
}

