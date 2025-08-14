//
//  User.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/10.
//

// Discussion Points: TDEE for individuals that don't identify with being male or female
import Foundation
import SwiftData


struct UserSettings: Codable {
    
    var name: String
    var age: Int
    var weight: Double
    var height: Double
    var sex: Sex
    var activityLevel: ActivityLevel
    var TDEE: Double {
        calculateTDEE(using: self.weight)
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case age = "age"
        case weight = "weight"
        case height = "height"
        case sex = "sex"
        case activityLevel = "activityLevel"
    }
    

    
    enum Sex: String, CaseIterable, Codable {
        case male, female
    }
    enum ActivityLevel: String, CaseIterable, Codable {
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
    
    
    
    
    // Amount of calories the User must eat to maintain their weight.
    // Calculate TDEE from a given weight
    func calculateTDEE(using weight: Double) -> Double {
        var bmr : Double
        
        switch sex {
        case .female:
            bmr =  10.0 * weight + 6.25 * height - 5.0 * Double(age)  - 161.0
        case .male:
            bmr =  10.0 * weight + 6.25 * height - 5.0 * Double(age) + 5.0
        }
        
        
        return bmr * self.activityLevel.multiplier
        
    }
    
   
    init() {
        self.name = ""
        self.age = 0
        self.weight = 0.0
        self.height = 0.0
        self.sex = .male
        self.activityLevel = .sedentary
    }
    
    init(name: String, age: Int, weight: Double, height: Double, sex: Sex, activityLevel: ActivityLevel) {
        self.name = name
        self.age = age
        self.weight = weight
        self.height = height
        self.sex = sex
        self.activityLevel = activityLevel
    }
    
   


    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.age = try container.decode(Int.self, forKey: .age)
        self.weight = try container.decode(Double.self, forKey: .weight)
        self.height = try container.decode(Double.self, forKey: .height)
        self.sex = try container.decode(UserSettings.Sex.self, forKey: .sex)
        self.activityLevel = try container.decode(UserSettings.ActivityLevel.self, forKey: .activityLevel)
     
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(age, forKey: .age)
        try container.encode(weight, forKey: .weight)
        try container.encode(height, forKey: .height)
        try container.encode(sex, forKey: .sex)
        try container.encode(activityLevel, forKey: .activityLevel)
    }
    
    
    
        
    static let example = UserSettings(name: "Kangiriyanka", age: 28, weight: 79, height: 176, sex: .male, activityLevel: .lightActivity)
        
        
    }



