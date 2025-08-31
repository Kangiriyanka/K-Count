//
//  FoodEnums.swift
//  K-Count
//
//  Created by Kangiriyanka The Single Leaf on 2025/08/31.
//

import Foundation

enum ServingType: String, CaseIterable {
   case cup = "cup"
   case ounce = "oz"
   case gram = "gram"
   case piece = "piece"
   case tablespoon = "tbsp"
   case teaspoon = "tsp"
   case pound = "lb"
   case milliliter = "ml"
   case serving = "serving"
   
   var displayName: String {
       switch self {
       case .cup: return "Cup (cup)"
       case .ounce: return "Ounce (oz)"
       case .gram: return "Gram (g)"
       case .piece: return "Piece (piece)"
       case .tablespoon: return "Tablespoon (tbsp)"
       case .teaspoon: return "Teaspoon (tsp)"
       case .pound: return "Pound (lb)"
       case .milliliter: return "Milliliter (ml)"
       case .serving: return "Serving (serving)"
       }
   }
   
   var pluralForm: String {
       switch self {
       case .cup: return "cups"
       case .ounce: return "oz"
       case .gram: return "grams"
       case .piece: return "pieces"
       case .tablespoon: return "tbsp"
       case .teaspoon: return "tsp"
       case .pound: return "lbs"
       case .milliliter: return "ml"
       case .serving: return "servings"
       }
   }
}
