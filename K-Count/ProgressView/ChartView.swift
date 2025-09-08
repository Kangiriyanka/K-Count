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
    @State private var selectedDates: [Date] = []
    
    private func getFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = selectedPeriod == .year ? "MMM" : "MM/dd"
        return formatter
    }
   
   
    

    
    private var filteredDays: [Day] {
           let cutoffDate = Calendar.current.date(byAdding: .day, value: -selectedPeriod.days, to: Date()) ?? Date()
           let filtered = days.filter { $0.date >= cutoffDate && $0.weight != 0.0 }

           switch selectedPeriod {
           case .week, .month:
               return filtered.sorted { $0.date < $1.date }
           case .year:
               return averageWeightPerMonth(from: filtered)
           }
       }


    private func averageWeightPerMonth(from days: [Day]) -> [Day] {
        let calendar = Calendar.current
        
        // Group days by first day of month
        let grouped = Dictionary(grouping: days) { day in
            calendar.date(from: calendar.dateComponents([.year, .month], from: day.date))!
        }

        // Compute average weight per month
        return grouped.map { (monthDate, daysInMonth) in
            let total = daysInMonth.reduce(0.0) { $0 + $1.weight }
            let average = total / Double(daysInMonth.count)
            return Day(date: monthDate, weight: average, foodEntries: [])
        }
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
    
    private var annotationStep:  Int {
        switch selectedPeriod {
        case .week, .year: return 1
        case .month: return 2
       
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
        
        PeriodPicker(selectedPeriod: $selectedPeriod).padding()
        
        if filteredDays.isEmpty {
            ZStack {
                VStack {
                    
                    
                    Text("No weight data available").fontWeight(.semibold).padding()
                        .font(.caption)
                   
                        
                    
                
                }
            }
        }
        // Overhead comes from having 365 LineMarks + 365 AreaMarks
        VStack {
            
            
            Chart(filteredDays.indices, id: \.self) { index in
                
                let day = filteredDays[index]
                
                
                
                    AreaMark(x: .value("Date", day.date),
                             yStart: .value("Baseline", customWeightRange.lowerBound),
                             yEnd: .value("Weight", day.weight))
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(linearGradient)
                    .interpolationMethod(.catmullRom)
                
                
                    
            
                
                
                LineMark(x: .value("Date", day.date),
                         y: .value("Weight", day.weight))
                .interpolationMethod(.catmullRom)
                
                
   
                if (index % annotationStep) == 0 {
                    PointMark(
                        x: .value("Date", day.date),
                        y: .value("Weight", day.weight)
                    )
                    .annotation(position: .top, spacing: 10) {
                        let weightValue = WeightValue.metric(day.weight)
                        Text(weightValue.graphDisplay(for: userSettings.weightPreference))
                            .font(.caption2)
                            .padding(2)
                    }
                    
                  
                }
                    
                    
                    
                    
                    
            }
        
            .frame(height: 275)
                
                   
                }
                
                .padding(15)
                .chartXAxis {
                    chartXAxis(filteredDays: filteredDays)
                }
                .chartYAxis {
                    chartYAxis(range: customWeightRange)
                }
        
               
                .chartYScale(domain: customWeightRange)
             
                .chartPlotStyle { plotArea in
                    plotArea
                        .background(.mint.opacity(0.03))
                        
                    
                                            
                }
                
            .chartScrollableAxes(selectedPeriod == .week ? [] : .horizontal)
            .background(Color(.secondarySystemGroupedBackground))
  
           
        
    }
    
    private func chartXAxis(filteredDays: [Day]) -> some AxisContent {
        let selectedDates = filteredDays.enumerated().compactMap { index, day in
                index % annotationStep == 0 ? day.date : nil
            }
        
        return AxisMarks(preset: .aligned, values: selectedDates) { value in
            AxisValueLabel {
                if let label = value.as(Date.self) {
                    Text(getFormatter().string(from: label))
                        .font(.caption2)
                        .padding([.top, .leading], 10)
                }
            }
            AxisGridLine(stroke: StrokeStyle(lineWidth: 0.2, dash: [2, 2]))
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
    
 
}

#Preview {
    ChartView(days: Day.examples)
    
}

#Preview {
   let testDays = [
       Day(date: Calendar.current.date(byAdding: .day, value: -10, to: Date())!, weight: 70.0, foodEntries: []),
       Day(date: Calendar.current.date(byAdding: .day, value: -20, to: Date())!, weight: 68.5, foodEntries: []),
       Day(date: Calendar.current.date(byAdding: .day, value: -30, to: Date())!, weight: 68.0, foodEntries: []),
       Day(date: Date(), weight: 67.5, foodEntries: [])
   ]
   ChartView(days: testDays)
}

#Preview {
    ChartView(days: [])
}
