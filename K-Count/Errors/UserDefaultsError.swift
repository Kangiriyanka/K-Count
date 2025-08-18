//
//  UserDefaultsError.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2025/07/06.
//

import Foundation

enum UserDefaultsError: LocalizedError {
    
    case encodingFailed
    case decodingFailed
    case noData
    

    var errorDescription: String? {
        switch self {
        case .encodingFailed:
            return "Failed to encode object to save in UserDefaults."
        case .decodingFailed:
            return "Failed to decode object from UserDefaults."
        case .noData:
            return "No data found in UserDefaults for the given key."
        }
    }
}
