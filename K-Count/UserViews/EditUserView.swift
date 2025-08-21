//
//  EditPersonView.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/10.
//

import SwiftUI

struct EditUserView: View {
    
    
    @AppStorage("userSettings") var userSettings = UserSettings()
    @State private var name: String = ""
    @State private var height: String = ""
    @State private var weight: String = ""
    @State private var age: String = ""
    @State private var sexAssigned: UserSettings.Sex = .male
    @State private var activityLevel: UserSettings.ActivityLevel = .sedentary
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showError = false
    
    
    
    @Environment(\.dismiss) private var dismiss
    
    
    
    var body: some View {
        NavigationStack {
            Form {
                
                Text("NO")
            }
        }
        
        
        
    }
}
