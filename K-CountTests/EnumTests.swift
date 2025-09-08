//
//  AmericanTests.swift
//  K-CountTests
//
//  Created by Kangiriyanka The Single Leaf on 2025/09/06.
//

import Foundation


import Testing
@testable import K_Count

struct HeightValueTests {
    
    @Test
    func metricToCentimeters() {
        let height = HeightValue.metric(180)
        #expect(height.asCentimeters == 180)
    }
    
    @Test
    func imperialToCentimeters() {
        let fi = HeightValue.FootInches(foot: 5, inches: 11)
        let height = HeightValue.imperial(fi)
        #expect(abs(height.asCentimeters - 180.34) < 0.1)
    }
    
    @Test
    func metricToFeetInches() {
        let height = HeightValue.metric(181)
        let fi = height.asFeetInches
        #expect(fi.foot == 5)
        #expect(fi.inches == 11)
    }
    
    @Test
    func imperialDescription() {
        let height = HeightValue.imperial(.init(foot: 6, inches: 2))
        #expect(height.feetInchesDescription == "6' 2''")
    }
    
    @Test
    func metricDescription() {
        let height = HeightValue.metric(175)
        #expect(height.centimetersDescription == "175 cm")
    }
    
    // New tests
    
    @Test
    func zeroHeightMetric() {
        let height = HeightValue.metric(0)
        #expect(height.asFeetInches.foot == 0)
        #expect(height.asFeetInches.inches == 0)
        #expect(height.centimetersDescription == "0 cm")
    }
    
    @Test
    func zeroHeightImperial() {
        let height = HeightValue.imperial(.init(foot: 0, inches: 0))
        #expect(height.asCentimeters == 0)
        #expect(height.feetInchesDescription == "0' 0''")
    }
    
    @Test
    func largeHeightMetric() {
        let height = HeightValue.metric(250)
        let fi = height.asFeetInches
        #expect(fi.foot >= 8)
    }
    
    @Test
    func conversionConsistency() {
        let heightMetric = HeightValue.metric(180)
        let fi = heightMetric.asFeetInches
        let heightImperial = HeightValue.imperial(fi)
        #expect(abs(heightImperial.asCentimeters - heightMetric.asCentimeters) < 0.5)
    }
}

struct WeightValueTests {
    
    @Test
    func metricToKilograms() {
        let weight = WeightValue.metric(70)
        #expect(abs(weight.asKilograms - 70) < 0.01)
    }
    
    @Test
    func imperialToKilograms() {
        let weight = WeightValue.imperial(154.3)
        #expect(abs(weight.asKilograms - 70) < 0.1)
    }
    
    @Test
    func metricToPounds() {
        let weight = WeightValue.metric(80)
        #expect(abs(weight.asPounds - 176.37) < 0.1)
    }
    
    @Test
    func imperialToPounds() {
        let weight = WeightValue.imperial(180)
        #expect(weight.asPounds == 180)
    }
    
    @Test
    func displayPreferenceMetric() {
        let weight = WeightValue.metric(72)
        #expect(weight.display(for: .metric) == "72.0 kg")
        #expect(weight.graphDisplay(for: .metric) == "72.0")
    }
    
    @Test
    func displayPreferenceImperial() {
        let weight = WeightValue.metric(72)
        #expect(weight.display(for: .imperial) == "158.7 lbs")
        #expect(weight.graphDisplay(for: .imperial) == "158.7")
    }
}
