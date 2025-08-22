//
//  DateError.swift
//  K-Count
//
//  Created by Kangiriyanka The Single Leaf on 2025/08/22.
//

import Foundation


enum DateError: LocalizedError {
    
    case invalidRange
    
    
    var errorDescription: String? {
        switch self {
        case .invalidRange:
            return "Failed to create a range"
            
        }
    }
}
