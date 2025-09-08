//
//  ChartView.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2025/07/06.
//

import SwiftUI
import Charts

private enum Period: String, CaseIterable {
    case week = "week"
    case month = "month"
    case year = "year"
    
    var days: Int {
        switch self {
        case .week: return 7
        case .month: return 30
        case .year: return 365
        }
    }
}

struct PeriodPicker: View {
    @Binding fileprivate var selectedPeriod: Period
    @Namespace private var namespace

    var body: some View {
        HStack {
            Text("Timeframe")
                .font(.headline)
            
            Picker("Timeframe", selection: $selectedPeriod) {
                ForEach(Period.allCases, id: \.self) { period in
                    Text(period.rawValue.capitalized)
                        .bold()
                        .tag(period)
                        
                }
           
            }
            
        }

        .smallDataCardStyle()
        
    }
}


struct ChartView: View {
    @AppStorage("userSettings") var userSettings = UserSettings()
    var days: [Day]
    @State private var selectedPeriod: Period = .week
   
   
    
   
    private var filteredDays: [Day] {
        let cutoffDate = Calendar.current.date(byAdding: .day, value: -selectedPeriod.days, to: Date()) ?? Date()
        
        return days
            .filter { $0.date >= cutoffDate && $0.weight != 0.0 }
            .sorted { $0.date < $1.date }
    }

    private var customWeightRange: ClosedRange<Double> {
        let recentWeights = filteredDays.map { $0.weight }
        
        
        guard let min = recentWeights.min(), let max = recentWeights.max() else {
            return userSettings.weight-1...userSettings.weight+1
        }
        let padding = [(max-min) * 0.1 , 1.0].max() ?? 1.0
        return (min - padding)...(max + padding)
    }
    
   


 
    private func annotationStep(for period: Period) -> Int {
        switch selectedPeriod {
        case .week: return 1
        case .month: return 5
        case .year: return 30
        }
    }
    
   
    
    let linearGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color.accentColor.opacity(0.4),
            Color.accentColor.opacity(0.3),
            Color.accentColor.opacity(0.1)
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    var body: some View {
        
        PeriodPicker(selectedPeriod: $selectedPeriod)
        
        if filteredDays.isEmpty {
            ZStack {
                VStack {
                    
                    
                    Text("No weight data available").fontWeight(.semibold).padding()
                        .font(.caption)
                   
                        
                    
                
                }
            }
        }
            VStack {
                    Chart(Array(filteredDays.enumerated()), id: \.offset) { index,day in
                        
                        AreaMark(x: .value("Date", day.date),
                                 yStart: .value("Baseline", customWeightRange.lowerBound),
                                 yEnd: .value("Weight", day.weight))
                        .foregroundStyle(linearGradient)
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(linearGradient)
                        .interpolationMethod(.catmullRom)
                        
                        LineMark(x: .value("Date", day.date),
                                 y: .value("Weight", day.weight))
                        .interpolationMethod(.catmullRom)
                        
                        
                       
                        if (index % annotationStep(for: selectedPeriod)) == 0 {
                            PointMark(
                                x: .value("Date", day.date),
                                y: .value("Weight", day.weight)
                            )
                            
                            .annotation(position: .top, spacing: 20) {
                                let weightValue = WeightValue.metric(day.weight)
                                Text(weightValue.graphDisplay(for: userSettings.weightPreference))
                                    .font(.caption2)
                                    .padding(2)
                            }
                        }
                        
                       
                        
                        
                        
                    }
                    .frame(height: 275)
                
                   
                }
                
                .padding()
                .chartXAxis {
                    chartXAxis(filteredDays: filteredDays, transformDate: transformDate)
                }
                .chartYAxis {
                    chartYAxis(range: customWeightRange)
                }
        
               
                .chartYScale(domain: customWeightRange)
                .chartPlotStyle { plotArea in
                    plotArea
                        .background(.mint.opacity(0.03))
                        
                    
                                            
                }
                
            .chartScrollableAxes(.horizontal)
            .background(Color(.secondarySystemGroupedBackground))
  
           
        
    }
    
    private func chartXAxis(filteredDays: [Day], transformDate: @escaping (Date) -> String) -> some AxisContent {
        let selectedDates = filteredDays.enumerated().compactMap { index, day in
                index % annotationStep(for: selectedPeriod) == 0 ? day.date : nil
            }
        
        return AxisMarks(preset: .aligned, values: selectedDates) { value in
            AxisValueLabel {
                if let label = value.as(Date.self) {
                    Text(transformDate(label))
                        .font(.caption2)
                        .padding([.top, .leading], 10)
                }
            }
            AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                .foregroundStyle(.gray)
        }
    }
    
    private func chartYAxis(range: ClosedRange<Double>) -> some AxisContent {
        AxisMarks(values: [range.lowerBound, range.upperBound]) { value in
            AxisValueLabel {
                if let weight = value.as(Double.self) {
                    let weightValue = WeightValue.metric(weight)
                    Text(weightValue.graphDisplay(for: userSettings.weightPreference))
                        .font(.caption2)
                }
            }
            AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                .foregroundStyle(.gray.opacity(0.5))
        }
    }
    
    
    private func transformDate (_ date: Date) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter.string(from: date)
        
    }
}

#Preview {
    ChartView(days: Day.examples)
    
}

#Preview {
   let testDays = [
       Day(date: Calendar.current.date(byAdding: .day, value: -10, to: Date())!, weight: 70.0, foodEntries: []), // 60 days ago
       Day(date: Calendar.current.date(byAdding: .day, value: -20, to: Date())!, weight: 68.5, foodEntries: []), // 5 days ago
       Day(date: Calendar.current.date(byAdding: .day, value: -30, to: Date())!, weight: 68.0, foodEntries: []), // 2 days ago
       Day(date: Date(), weight: 67.5, foodEntries: []) // Today
   ]
   ChartView(days: testDays)
}

#Preview {
    ChartView(days: [])
}
