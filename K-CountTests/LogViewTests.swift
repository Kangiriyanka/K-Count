//
//  LogViewTests.swift
//  K-CountTests
//
//  Created by Kangiriyanka The Single Leaf on 2025/09/05.
//

import Testing
@testable import K_Count
import SwiftData
import SwiftUI

struct LogViewTests {

    private func makeContainer() throws -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try ModelContainer(for: Food.self, Day.self, configurations: config)
    }
    
   
    @MainActor
    @Test func testCreateDay() throws {
        let container = try makeContainer()
        let modelContext = container.mainContext
        
        let day = Day(date: Date(), weight: 70.0, foodEntries: [])
        modelContext.insert(day)
        try modelContext.save()

        let days = try modelContext.fetch(FetchDescriptor<Day>())
        #expect(days.count == 1)
        #expect(days.first?.weight == 70.0)
    }

    @MainActor
    @Test func testLogViewCreation() {
        let _ = LogView()
        // Just test it compiles and initializes
        #expect(true)
    }
}
