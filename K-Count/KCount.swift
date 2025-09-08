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
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(for: Day.self)
    }
}

#Preview("Onboarded") {
    RootView()
        .modelContainer(for: Day.self, inMemory: true)
}

#Preview("Not Onboarded") {
    
    RootView(hasOnboarded: false)
    
}

