import SwiftUI
import SwiftData

enum Modes: String, CaseIterable {
    case search = "My Foods"
    case addNew = "New Food"
}

struct CustomPicker: View {
    @Binding var selectedMode: Modes
    @Namespace private var namespace

    var body: some View {
        HStack {
            ForEach(Modes.allCases, id: \.self) { mode in
                Button(action: {
                    withAnimation {
                        selectedMode = mode
                    }
                }) {
                    Text(mode.rawValue)
                        .font(.headline)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            ZStack {
                                if selectedMode == mode {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.accentColor)
                                        .matchedGeometryEffect(id: "background", in: namespace)
                                }
                            }
                        )
                       
                }
                .buttonStyle(.plain)
            }
        }

        .frame(maxWidth: .infinity)
    }
}

struct AddFoodView: View {
    @Environment(\.dismiss) var dismiss
    @Query var foods: [Food]
    @Bindable var day: Day
    @State private var foodsAdded: [FoodEntry] = []
    @State private var searchText: String = ""
    @State private var selectedMode: Modes = .search
    @State private var showingPopover: Bool = false
    @State private var isClicked = false

    var filteredFoods: [Food] {
        let filtered = if searchText.isEmpty {
            foods
        } else {
            foods.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        return filtered.sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
         
                CustomPicker(selectedMode: $selectedMode)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color(.secondarySystemGroupedBackground)))
                    .shadow(radius: 2, x: 0, y: 0.2)

             
                Group {
                    if selectedMode == .addNew {
                        NewFoodView(foodsAdded: $foodsAdded)
                            .transition(.move(edge: .trailing).combined(with: .opacity))
                    }
                    if selectedMode == .search {
                        foodListSection
                            .transition(.move(edge: .leading).combined(with: .opacity))
                    }
                }
            
                .animation(.easeInOut(duration: 0.25), value: selectedMode)

                Spacer()
            }
            .padding(.horizontal)
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    basketButton
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    actionButtons
                }
            }
        }
    }



    private var foodListSection: some View {
        Group {
            if filteredFoods.isEmpty {
                ContentUnavailableView {
                    Label("No foods found", systemImage: "basket")
                } description: {
                    Text("Try adjusting your search to see results.")
                }
            } else {
                List {
                    Section("Available Foods") {
                    ForEach(filteredFoods, id: \.id) { food in
                        NavigationLink(destination: FoodView(food: food, foodsAdded: $foodsAdded)) {
                            VStack(alignment: .leading) {
                                Text(food.name)
                                HStack {
                                    (Text(food.calories.formatted() + " cal")
                                     + Text(" / \(food.servingType)"))
                                    .foregroundStyle(.secondary)
                                }
                            }
                        }
                       
                    }
                  }
                }
               
                .scrollContentBackground(.hidden)
               
            }
        }
    }

    private var basketButton: some View {
        Button {
            showingPopover = true
            isClicked.toggle()
        } label: {
            Image(systemName: "basket")
                .font(.title2)
        }
        .symbolEffect(.wiggle, value: isClicked)
        .overlay(
            ZStack {
                Circle()
                    .stroke(Color.emeraldGreen, lineWidth: 1)
                    .frame(width: 15, height: 15)
                Text(String(foodsAdded.count)).bold()
                    .font(.caption)
            },
            alignment: .topTrailing
        )
        .popover(isPresented: $showingPopover) {
            FoodsAddedView(foodsAdded: $foodsAdded)
                .frame(minWidth: 300, maxHeight: 400)
                .presentationCompactAdaptation(.popover)
        }
    }

    private var actionButtons: some View {
        HStack {
            Button("Cancel", role: .cancel) {
                dismiss()
            }
            .foregroundColor(.red)

            Button("Done") {
                updateFoodEntries()
                dismiss()
            }
        }
    }
    // If our day doesn't contain the food entry, add it
    // Otherwise, update the portions
    // You have to explicitly define the relationship from FoodEntry to Day
    
    private func updateFoodEntries() {
        
        
        for entry in foodsAdded {
            if !day.foodEntries.contains(where: {$0.food.name == entry.food.name}) {
                //*** Here
                entry.day = day
                day.foodEntries.append(entry)
            }
            else {
                
                day.foodEntries.first(where: {$0.food.name == entry.food.name})?.servingSize = entry.servingSize
            }
            
        }
    }
}

#Preview {
   AddFoodView(day: Day.example)
        .modelContainer(Food.previewContainer())
}
