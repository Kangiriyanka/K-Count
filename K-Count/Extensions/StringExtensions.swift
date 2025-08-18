//
//  StringExtensions.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/27.
//

import Foundation

extension String {
    
        func trim() -> String {
            let result = self
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .replacingOccurrences(of: "[^a-zA-Z_]", with: "", options: .regularExpression)
                .lowercased()
            return result
       }
    
 
    
  
    }

