//
//  Enums.swift
//  K-Count
//
//  Created by Kangiriyanka The Single Leaf on 2025/08/21.
//

import Foundation


// ---- Enums for Height/Weight Conversions  ---- //
// For the Picker
enum MeasurementSystem: String, Codable, CaseIterable {
    case metric = "Metric"
    case imperial = "Imperial"
    
}

// Enum for conversions
// If you want to use onChange, you need to add the Equatable Protocol to
// its children structs
enum HeightValue: Equatable, Hashable{

    case metric(Double)
    case imperial(FootInches)
    
    // Needs to conform to Equatable
    struct FootInches: Equatable, Hashable {
        let foot: Int
        let inches: Int
        
        var totalInches: Double {
            Double(foot * 12 + inches)
            }
    }
    
    var asCentimeters: Double {
        switch self {
        case .metric(let value): return value
        case .imperial(let fi): return (Double(fi.foot) * 30.48) + (Double(fi.inches) * 2.54)
        }
    }
    
    var asFeetInches: FootInches {
        switch self {
        case .imperial(let fi): return fi
        case .metric(let value):
            let totalInches = value / 2.54
            let f = Int(totalInches) / 12
            let i = Int(totalInches) % 12
            return FootInches(foot: f, inches: i)
        }
    }
    
    var centimetersDescription: String {
        
        String(format: "%.0f cm", asCentimeters)
    }
    
    var feetInchesDescription: String {
        "\(asFeetInches.foot)' \(asFeetInches.inches)''"
    }
}

enum WeightValue: Equatable {
    case metric(Double)
    case imperial(Double)
    
    var asKilograms: Double {
        switch self {
        case .metric(let value): return value
        case .imperial(let value): return value / 2.20462
        }
    }
    
    var asPounds: Double {
        switch self {
        case .imperial(let value): return value
        case .metric(let value): return value * 2.20462
        }
    }
    
    var kilogramsDescription: String {
        String(format: "%.1f kg", asKilograms)
    }
    
    var kilogramsDescriptionShort: String {
        String(format: "%.1f", asKilograms)
    }
    
    var poundsDescription: String {
        String(format: "%.1f lbs", asPounds)
    }
    
    var poundsDescriptionShort: String {
        String(format: "%.1f", asPounds)
    }
    
    
    func display(for preference: MeasurementSystem) -> String {
           switch preference {
           case .metric: return kilogramsDescription
           case .imperial: return poundsDescription
           }
       }
    
    func graphDisplay(for preference: MeasurementSystem) -> String {
           switch preference {
           case .metric: return kilogramsDescriptionShort
           case .imperial: return poundsDescriptionShort
           }
       }
}
