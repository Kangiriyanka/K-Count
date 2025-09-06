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
    case analytics
    case export


    var title: String {
        switch self {
        case .day:
            return "Log"
        case .analytics:
            return "Progress"
        case .export:
            return "Data"
            
        }
    }
        
    var iconName: String{
            switch self {
            case .day:
                return "list.clipboard"
            case .analytics:
                return "chart.xyaxis.line"
            case .export:
                return "numbers.rectangle"
                
            }
        }
}
    
