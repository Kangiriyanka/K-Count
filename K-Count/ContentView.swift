//
//  ContentView.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/10.
//

import SwiftUI
import SwiftData

struct ContentView: View {

    @State private var selectedTab = 0
    @AppStorage("userSettings") var userSettings = UserSettings()
    
  
    
    var body: some View {
        
    
    
        if (userSettings.name != "") {
            
            ZStack(alignment: .bottom) {
                
                
                TabView(selection: $selectedTab){
                    
                    LogView()
                        .tag(0)
                    
                    
                    ProgressView()
                        .tag(1)
                    
                    DataView()
                        .tag(2)
                    
                    
                    
                }
                
            }
            
            
            
            
            ZStack {
                HStack {
                    ForEach(TabbedItems.allCases, id: \.self) { item in
                        Button(action: {
                            selectedTab = item.rawValue
                        }) {
                            VStack {
                                CustomTabItem(
                                    imageName: item.iconName,
                                    title: item.title,
                                    isActive: selectedTab == item.rawValue
                                )
                                Text(item.title)
                                    .font(.system(size: 10))
                                    .foregroundStyle(selectedTab == item.rawValue ? Color.accentColor: Color.gray)
                                
                            }
                        }
                    }
                }
                
                .padding()
                .ignoresSafeArea(.keyboard, edges: .bottom)
                .toolbar(.hidden, for: .tabBar)
                
                
            }
            
            .frame(height: 60)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 2, x: 0, y: 1)
            .padding(.horizontal, 35)
        } else {
            OnboardingView()
            
            
            
     }
       
        
    
     
      
        
        
      
        
        
            
            
            
            
        }
    }
    

#Preview {
  
    return ContentView()
     
       
}
