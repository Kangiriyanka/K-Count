//
//  UserExtension.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2025/07/07.
//

import Foundation

//

extension UserSettings: RawRepresentable {
    // The raw value is what is stored in AppStorage.
    // What you save to App Storage.
    var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let userSettingsString = String(data: data, encoding: .utf8)
                
        else {
            return "{}"
        }
        return userSettingsString
    }
    
    // App Storage extracts this behind the scenes
    init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let userSettings = try? JSONDecoder().decode(UserSettings.self, from: data)
        else {return nil}
        
        self = userSettings
        
    }
    
    
}
