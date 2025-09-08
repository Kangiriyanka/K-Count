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
   
   var body: some View {
       
       ZStack(alignment: .bottom) {
           TabView(selection: $selectedTab) {
               LogView().tag(0)
               ProgressView().tag(1)
               DataView().tag(2)

               
           }
          
           
           /// Custom Tab Bar
           /// TabbedItems are day, analytics, export
           /// The CustomTabItem is an Image with 2 Spacers
           
           HStack {
               ForEach(TabbedItems.allCases, id: \.self) { item in
                   Button {
                       selectedTab = item.rawValue
                   } label: {
                       VStack(spacing: 4) {
                           CustomTabItem(
                               imageName: item.iconName,
                               title: item.title,
                               isActive: selectedTab == item.rawValue
                           )
                           Text(item.title)
                               .font(.system(size: 10))
                               .foregroundStyle(selectedTab == item.rawValue ? .accent : .gray)
                       }
                   }
               }
           }
           .padding()
           .frame(height: 60)
           .background(
               RoundedRectangle(cornerRadius: 20)
                   .fill(Color(.secondarySystemGroupedBackground))
                   .shadow(color: Color.primary.opacity(0.1), radius: 1, x: 0, y: -1)
                   .shadow(color: Color.primary.opacity(0.1), radius: 2, x: 2, y: 2)
           )
         
           .padding(.horizontal, 35)
         
       }
       .ignoresSafeArea(.keyboard, edges: .bottom)
     
   }
}

#Preview {
   ContentView()
        .modelContainer(Day.previewContainer())
}
