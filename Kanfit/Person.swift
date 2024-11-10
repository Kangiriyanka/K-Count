//
//  Person.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/10.
//

import Foundation


@Observable
class Person {
    
    var name: String
    var age: Int
    var weight: Double
    var height: Double
    var sex: Sex
    var activityLevel: ActivityLevel
    
    enum Sex: String {
        case male, female
    }
    enum ActivityLevel: String, CaseIterable {
        case sedentary = "Sedentary"
        case lightActivity = "Light Activity"
        case moderateActivity = "Moderate Activity"
        case vigorousActivity = "Vigorous Activity"
        
    
        
        var multiplier: Double {
                switch self {
                case .sedentary: return 1.2
                case .lightActivity: return 1.375
                case .moderateActivity: return 1.55
                case .vigorousActivity: return 1.725
                }
            }
    }
    
    
    var BMR: Double {
        
        switch sex {
        case .female:
            return 10.0 * weight + 6.25 * height - 5.0 * Double(age)  - 161.0
        case .male:
            return 10.0 * weight + 6.25 * height - 5.0 * Double(age) + 5.0
        }
    }
    
    
    var TDEE: Int {
        
        return Int(BMR * activityLevel.multiplier)
    }
    
    init(name: String, age: Int, weight: Double, height: Double, sex: Sex, activityLevel: ActivityLevel) {
        self.name = name
        self.age = age
        self.weight = weight
        self.height = height
        self.sex = sex
        self.activityLevel = activityLevel
    }
    
    static let example = Person(name: "Kangiriyanka", age: 28, weight: 79, height: 176, sex: .male, activityLevel: .lightActivity)
    

}


