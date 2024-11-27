//
//  Food.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/10.
//

import Foundation

struct Food: Hashable, Codable{
    
   
    var name: String
    var calories: Double
    var servingType: String
    
    func writeFood() {
        
        print(URL.documentsDirectory.appendingPathComponent("food.json"))
        
        
    }
    
    static let example = Food( name: "Reese Peanut Butter Cup", calories: 150, servingType: "piece")
    static let another_example =  Food(name: "Steak", calories: 3, servingType: "gram")
    
    
    
}
