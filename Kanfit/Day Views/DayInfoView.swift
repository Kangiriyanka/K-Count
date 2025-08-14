
import SwiftUI
import SwiftUI


struct DayInfoView: View {
    
    
    var day: Day
    var totalCalories: String
    var remainingCalories: String
    @State private var scaleAmount = 1.0
    
    var body: some View {
        

            VStack {
               
                
                   
                HStack {
                    Group {
                        VStack {
                            Text("Weight (kg)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            // The default weight when a day is created is 0.0kg
                            if day.weight == 0.0 {
                                Text(Image(systemName: "pencil")).overlay(
                                    NavigationLink(destination: EditCurrentWeightView(day: day), label: {})
                                        .opacity(0)
                                )
                                // Prevents the default chevron of the NavigationStack from showing
                                
                            } else {
                                Text("\(day.formattedWeight)").bold()
                                    .overlay(
                                        NavigationLink(destination: EditCurrentWeightView(day: day), label: {})
                                            .opacity(0)
                                    )
                                // Prevents the default chevron of the NavigationStack from showing
                                
                            }
                        }
                        Divider()
                            .padding(.horizontal, 16) // Padding on left and right
                            .padding(.vertical, 8)    // Padding on top and bottom
                      
                        
             
                        VStack {
                            
                            
                            Text("Calories")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text("\(totalCalories)").bold()
                                .contentTransition(.numericText())
                            
                                
                            
                            
                        }
                        Divider()
                            .padding(.horizontal, 16) // Padding on left and right
                            .padding(.vertical, 8)    // Padding on top and bottom
                      
                        
                        
                        VStack {
                            Text("Remaining")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text("\(remainingCalories) ").bold()
                                .contentTransition(.numericText())
                               
                            
                            
                        }
                        
                       
                    }
                    
                    
                 
                  
                    
                   
                   
                    
                    
                    
                 
                }
                .frame(maxWidth: .infinity)
              
               
               

              
            }
            
           
           
        }
      
    }




#Preview {
    DayInfoView(day: Day.example,  totalCalories: "1000", remainingCalories: "500")
}
