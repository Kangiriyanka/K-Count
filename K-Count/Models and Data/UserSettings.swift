//
//  User.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/10.
//

import Foundation
import SwiftData

struct UserSettings: Codable {

    var name: String
    var birthday: Date
    var weight: Double
    var height: Double
    var sex: Sex
    var activityLevel: ActivityLevel
    var measurementPreference: MeasurementSystem
    
    var TDEE: Double {
        calculateTDEE(using: weight)
    }
    
    var age: Int {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthday, to: Date())
        return ageComponents.year ?? 0
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
    

    
    init(
        name: String = "",
        birthday: Date = Date(),
        weight: Double = 0.0,
        height: Double = 0.0,
        sex: Sex = .male,
        activityLevel: ActivityLevel = .sedentary,
        measurementPreference: MeasurementSystem = .metric
    ) {
        self.name = name
        self.birthday = birthday
        self.weight = weight
        self.height = height
        self.sex = sex
        self.activityLevel = activityLevel
        self.measurementPreference = measurementPreference
    }
    
    // MARK: - Codable
    
    enum CodingKeys: String, CodingKey {
        case name, birthday, weight, height, sex, activityLevel, measurementPreference
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.birthday = try container.decode(Date.self, forKey: .birthday)
        self.weight = try container.decode(Double.self, forKey: .weight)
        self.height = try container.decode(Double.self, forKey: .height)
        self.sex = try container.decode(Sex.self, forKey: .sex)
        self.activityLevel = try container.decode(ActivityLevel.self, forKey: .activityLevel)
        self.measurementPreference = try container.decode(MeasurementSystem.self, forKey: .measurementPreference)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(birthday, forKey: .birthday)
        try container.encode(weight, forKey: .weight)
        try container.encode(height, forKey: .height)
        try container.encode(sex, forKey: .sex)
        try container.encode(activityLevel, forKey: .activityLevel)
        try container.encode(measurementPreference, forKey: .measurementPreference)
    }
    
  
    
    func calculateTDEE(using weight: Double) -> Double {
        let bmr: Double
        switch sex {
        case .female:
            bmr = 10 * weight + 6.25 * height - 5 * Double(age) - 161
        case .male:
            bmr = 10 * weight + 6.25 * height - 5 * Double(age) + 5
        }
        return bmr * activityLevel.multiplier
    }
    

    
    static let example = UserSettings(
        name: "Kangiriyanka",
        birthday: Calendar.current.date(byAdding: .year, value: -29, to: Date()) ?? Date(),
        weight: 79,
        height: 176,
        sex: .male,
        activityLevel: .lightActivity,
        measurementPreference: .metric
    )
}
