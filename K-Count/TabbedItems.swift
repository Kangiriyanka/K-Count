//
//  TabbedItems.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2025/01/03.
//

import Foundation

// Implicit Raw Values, Remember? ;)
enum TabbedItems: Int, CaseIterable{
    case day = 0
    case progress
    case data


    var title: String {
        switch self {
        case .day:
            return "Log"
        case .progress:
            return "Progress"
        case .data:
            return "Data"
            
        }
    }
        
    var iconName: String{
            switch self {
            case .day:
                return "list.clipboard"
            case .progress:
                return "chart.xyaxis.line"
            case .data:
                return "numbers.rectangle"
                
            }
        }
}
    
