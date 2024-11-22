//
//  Food.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/10.
//

import Foundation

struct Food: Hashable, Codable, Identifiable{
    
    var id : Int
    var name: String
    var calories: Double
    
    func writeFood() {
        
        print(URL.documentsDirectory.appendingPathComponent("food.json"))
        
        
    }
    
    static let example = Food(id: 1, name: "Reese Peanut Butter Cup", calories: 150)
    
    
    
}
