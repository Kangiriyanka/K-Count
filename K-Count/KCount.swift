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
        if hasOnboarded {
            ContentView()
        } else {
            OnboardingView()
        }
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
    OnboardingView()
        .modelContainer(for: Day.self, inMemory: true)
}
