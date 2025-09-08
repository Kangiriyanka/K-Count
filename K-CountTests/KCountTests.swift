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
        
        // Create food
        let food = Food(name: "Test Food", calories: 100, servingType: "piece")
        modelContext.insert(food)
        
        // Create entries and set the to-one relationship explicitly
        let entry1 = FoodEntry(food: food, servingSize: 1.0)
        let entry2 = FoodEntry(food: food, servingSize: 2.0)
        food.entries = [entry1,entry2]
        modelContext.insert(entry1)
        modelContext.insert(entry2)
        
        // Add entries to the food's entries array (inverse relationship)
        food.entries = [entry1, entry2]
        
        try modelContext.save()
        
        // Verify setup
        let allFoods = try modelContext.fetch(FetchDescriptor<Food>())
        let allEntries = try modelContext.fetch(FetchDescriptor<FoodEntry>())
        #expect(allFoods.count == 1)
        #expect(allEntries.count == 2)
        
        // Test cascade deletion
        for entry in food.entries {
            modelContext.delete(entry)
        }
        try modelContext.save()
        modelContext.delete(food)
        try modelContext.save()
        
        // Verify cascade delete worked
        let remainingFoods = try modelContext.fetch(FetchDescriptor<Food>())
        let remainingEntries = try modelContext.fetch(FetchDescriptor<FoodEntry>())
        #expect(remainingFoods.count == 0)
        #expect(remainingEntries.count == 0)
    }
}
