//
//  AboutView.swift
//  K-Count
//
//  Created by Kangiriyanka The Single Leaf on 2025/08/29.
//

import SwiftUI
import StoreKit

struct AboutView: View {
   @Environment(\.requestReview) private var requestReview
   
   var body: some View {
       ScrollView {
           VStack(alignment: .leading, spacing: 24) {
               
               VStack(alignment: .leading, spacing: 12) {
                   Text("Weight Loss Simplified")
                       .font(.headline)
                       .fontWeight(.semibold)
                   
                   Text("Your body burns a set amount of calories each day — your TDEE (Total Daily Energy Expenditure). To reach your goal, you simply need to eat above or below that number. K-Count keeps it simple by helping you stay mindful and focused.")
                       .font(.body)
                       .lineSpacing(2)
               }
               
               Divider()
               
               VStack(alignment: .leading, spacing: 12) {
                   Text("About K-Count")
                       .font(.headline)
                       .fontWeight(.semibold)
                   
                   Text("K-Count was created for people who want a simple, focused way to track calories and see their weight progress. Just the essentials: calorie tracking, weight tracking, and data export.")
                       .font(.body)
                       .lineSpacing(2)
               }
               
               Divider()
               
               VStack(alignment: .leading, spacing: 12) {
                   Text("Support the App")
                       .font(.headline)
                       .fontWeight(.semibold)
                   
                   Text("If you like the app, please rate it and leave a review.")
                       .font(.footnote)
                       .foregroundStyle(.secondary)
                   
                   Button("Leave a Review") {
                       requestReview()
                   }
                   .buttonStyle(.borderedProminent)
                   .controlSize(.regular)
               }
               
               
           }
           .padding()
       }
   }
}

#Preview {
   AboutView()
}
