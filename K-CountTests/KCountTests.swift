import Testing
@testable import K_Count
import SwiftData

struct KCountTests {

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }
    
    @MainActor @Test func testCascadeDeleteWithCodable() throws {
        // Setup SwiftData container for testing
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Food.self, FoodEntry.self, configurations: config)
        let modelContext = container.mainContext
        
        // Create food with entries
        let food = Food(name: "Test Food", calories: 100, servingType: "piece")
        let entry1 = FoodEntry(food: food, servingSize: 1.0)
        let entry2 = FoodEntry(food: food, servingSize: 2.0)
        
        food.entries.append(entry1)
        food.entries.append(entry2)
        
        // Insert into context
        modelContext.insert(food)
        modelContext.insert(entry1)
        modelContext.insert(entry2)
        try modelContext.save()
        
        // Verify setup
        let allFoods = try modelContext.fetch(FetchDescriptor<Food>())
        let allEntries = try modelContext.fetch(FetchDescriptor<FoodEntry>())
        #expect(allFoods.count == 1)
        #expect(allEntries.count == 2)
        
        // Test the problematic deletion
        modelContext.delete(food)
        try modelContext.save()
        
        // Verify cascade delete worked
        let remainingFoods = try modelContext.fetch(FetchDescriptor<Food>())
        let remainingEntries = try modelContext.fetch(FetchDescriptor<FoodEntry>())
        #expect(remainingFoods.count == 0)
        #expect(remainingEntries.count == 0)
    }
}
