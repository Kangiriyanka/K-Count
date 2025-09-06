import SwiftUI
import SwiftData

struct SwiftDataDebugView: View {
    @Environment(\.modelContext) var modelContext
    @Query private var foods: [Food]

    var body: some View {
        NavigationStack {
            List {
                Section("All Foods (\(foods.count))") {
                    ForEach(foods, id: \.id) { food in
                        VStack(alignment: .leading) {
                  
                            Text("Name: \(food.name)")
                                .foregroundColor(food.name.isEmpty ? .red : .primary)
                            Text("Calories: \(food.calories)")
                            Text("Serving: \(food.servingType)")
                                .foregroundColor(food.servingType.isEmpty ? .red : .primary)
                            Text("Entries: \(food.entries.count)")
                        }
                        .font(.caption)
                    }
                }

                Button("Delete Corrupted Foods") {
                    removeCorruptedFoods()
                }
                .foregroundColor(.red)
            }
            .navigationTitle("SwiftData Debug")
        }
    }

    private func removeCorruptedFoods() {
        // Fetch all foods manually to catch nils
        do {
            let allFoods = try modelContext.fetch(FetchDescriptor<Food>())
            for food in allFoods {
                if food.name.isEmpty || food.servingType.isEmpty || food.calories <= 0 {
                    print("Deleting corrupted food: \(food.id)")
                    modelContext.delete(food)
                }
            }
            try modelContext.save()
            print("Corrupted foods cleaned.")
        } catch {
            print("Error fetching/deleting foods: \(error)")
        }
    }
}
