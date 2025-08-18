//
//  TabbedItems.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2025/01/03.
//

import Foundation


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
            return "Export"
            
        }
    }
        
        var iconName: String{
            switch self {
            case .day:
                return "list.clipboard"
            case .analytics:
                return "chart.bar.fill"
            case .export:
                return "square.and.arrow.up"
                
            }
        }
}
    
