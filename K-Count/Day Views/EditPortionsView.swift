

import SwiftUI

struct EditPortionsView: View {
    
    @State private var servingSize: Double
    @State private var rawServingSize: String = ""
    @State private var totalCalories: Double
    @FocusState private var isServingSizeFocused: Bool
    @Environment(\.dismiss) private var dismiss
    let foodEntry: FoodEntry
    var body: some View {
        
        NavigationStack {
            
                VStack(alignment: .leading) {
                    Text(foodEntry.food.name).font(.title).bold()
                    Text("per " + foodEntry.food.servingType.lowercased())
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
                        
                        // Focus the field ot be edited when user clicks on the FoodRow.
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
    
      
        .navigationTitle("Edit \(foodEntry.food.name)")
        .navigationBarTitleDisplayMode(.inline)
      
        
    }
    

    
    func calculateCalories() {
        if let servingSize = Double(rawServingSize) {
            totalCalories = servingSize * foodEntry.food.calories
            self.servingSize = servingSize
        }
        
        
        
    }
    
    init(foodEntry: FoodEntry) {
       
        self.foodEntry = foodEntry
        self.servingSize = foodEntry.servingSize
        self.totalCalories = foodEntry.servingSize * foodEntry.food.calories
        _rawServingSize = State(initialValue: String(servingSize))
            
        }
      
        
        
    
}
    
      

#Preview {
    
    EditPortionsView(foodEntry: FoodEntry.example)
  
  
}
