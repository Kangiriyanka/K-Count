import SwiftUI

struct EditPortionsView: View {
    
    @State private var servingSize: Double
    @State private var rawServingSize: String = ""
    @State private var totalCalories: Double
    @FocusState private var isServingSizeFocused: Bool
    @Environment(\.dismiss) private var dismiss
    let foodEntry: FoodEntry
    
    var body: some View {
        let food = foodEntry.food
            NavigationStack {
                VStack(alignment: .leading) {
                    Text(food.name).font(.title).bold()
                    Text("per " + food.servingType.lowercased())
                    Divider()
                    
                    HStack {
                        Text("Servings")
                        Spacer()
                        TextField("Servings", text: $rawServingSize)
                            .keyboardType(.decimalPad)
                            .limitDecimals($rawServingSize, decimalLimit: 1, prefix: 4)
                            .onChange(of: rawServingSize) {
                                calculateCalories()
                            }
                            .focused($isServingSizeFocused).onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    isServingSizeFocused = true
                                }
                            }
                        
                        Text("\(totalCalories, specifier: "%.0f") cals")
                        
                    }.multilineTextAlignment(.center)
                        .padding()
                    
                    Divider()
                    HStack {
                        Spacer()
                        Button {
                            foodEntry.servingSize = servingSize
                            dismiss()
                        } label: {
                            Image(systemName: "pencil")
                                .scaledToFill()
                        }
                        .buttonStyle(AddButton())
                        .padding()
                        Spacer()
                    }
                }
                .padding()
                .onTapGesture {
                    self.endTextEditing()
                }
            }
            .navigationTitle("Edit \(food.name)")
            .navigationBarTitleDisplayMode(.inline)
        }
    
    
    func calculateCalories() {
        let food = foodEntry.food
        if let servingSize = Double(rawServingSize) {
            totalCalories = servingSize * food.calories
            self.servingSize = servingSize
        }
    }
    
    init(foodEntry: FoodEntry) {
        self.foodEntry = foodEntry
        self.servingSize = foodEntry.servingSize
        self.totalCalories = foodEntry.servingSize * (foodEntry.food.calories )
        _rawServingSize = State(initialValue: String(foodEntry.servingSize))
    }
}

#Preview {
    EditPortionsView(foodEntry: FoodEntry.example)
}
