//
//  SwiftUIView.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/10.
//

import SwiftUI
import SwiftData


struct ProgressView: View {
    @AppStorage("userSettings") var userSettings = UserSettings()
    @Query(filter: #Predicate<Day> { day in
        day.weight > 0}, sort: [SortDescriptor(\Day.date)]) var days : [Day]
    
    
    
    var body: some View {
        NavigationStack {
            
            ScrollView {
                
                
                VStack {
                    
                    ChartView(days: days)
                    
                    HStack {
                        
                        Spacer()
                        VStack {
                            Text("Current weight (kg)").italic().foregroundStyle(.secondary)
                                .font(.caption2)
                            
                            
                            
                            Text(String(format: "%0.1f", userSettings.weight))
                                .font(.title)
                                .bold()
                                .padding(.bottom, 4)
                                .overlay(
                                    Color.burntOrange
                                        .frame(height: 3),
                                    alignment: .bottom)
                        }
                        .smallDataCardStyle()
                        
                        
                        
                        Spacer()
                        
                        
                        VStack{
                            Text("Maintenance calories").italic().foregroundStyle(.secondary)
                                .font(.caption2)
                            
                            
                            Text(String(format: "%0.f", userSettings.TDEE))
                                .font(.title)
                                .bold()
                                .padding(.bottom, 4)
                                .overlay(
                                    Color.burntOrange
                                        .frame(height: 3),
                                    alignment: .bottom)
                            
                        }
                        .smallDataCardStyle()
                        
                        
                        
                        Spacer()
                    }
                }
                
                
                
                
                
                
                
                
                .toolbar {
                  
                }
                .navigationBarTitle("Progress", displayMode: .inline)
            }
            
            
        }
        
        
        
        
        
    }
}

#Preview {

    ProgressView()
      
}
