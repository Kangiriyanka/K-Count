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
            ForEach(Period.allCases, id: \.self) { period in
                Button(action: {
                    
                        selectedPeriod = period
                    
                }) {
                    Text(period.rawValue)
                        .font(.headline)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            ZStack {
                                if selectedPeriod == period {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.accentColor)
                                        .matchedGeometryEffect(id: "background", in: namespace)
                                }
                            }
                        )
                        .foregroundColor(selectedPeriod == period ? .white : .black)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 8).fill(Color.white))
        .shadow(radius: 2, x: 0, y: 0.2)
        .frame(maxWidth: .infinity)
    }
}


struct ChartView: View {
    @AppStorage("userSettings") var userSettings = UserSettings()
    var days: [Day]
    @State private var selectedPeriod: Period = .week
   
   
    
    private var filteredDays: [Day] {
        Array(days.suffix(selectedPeriod.days))
    }
    
    private var customDomain: ClosedRange<Double> {
        let recentWeights = days.suffix(selectedPeriod.days).filter({$0.weight != 0.0}).map{$0.weight}
        
       
        
        guard let min = recentWeights.min(), let max = recentWeights.max() else {
            return userSettings.weight-5...userSettings.weight+5
        }
        let padding = [(max-min) * 0.1 , 0.4].max() ?? 0.5
        return (min - padding)...(max + padding)
    }
    
    private var chartWidth: CGFloat {
    switch selectedPeriod {
    case .week: return 350
    case .month: return 600
    case .year: return 1200
    }
}
    
    private var spacingCount: Int {
        switch selectedPeriod {
        case .week: return 1
        case .month: return 5
        case .year: return 30
        }
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
            Color.white.opacity(0.2) // Even more subtle
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    var body: some View {
        
        PeriodPicker(selectedPeriod: $selectedPeriod)
        
        VStack {
       

     
            ScrollView(.horizontal, showsIndicators: false) {
                Chart(Array(filteredDays.enumerated()), id: \.offset) { index,day in
                    
                    LineMark(x: .value("Year", day.date),
                             y: .value("Weight", day.weight))
                    .interpolationMethod(.catmullRom)
                    
                    
                    
                    
                    if index.isMultiple(of: annotationStep(for: selectedPeriod)) {
                            PointMark(
                                x: .value("Date", day.date),
                                y: .value("Weight", day.weight)
                            )
                            .annotation(position: .top, spacing: 20) {
                                let weightValue = WeightValue.metric(day.weight)
                                Text(weightValue.graphDisplay(for: userSettings.weightPreference))
                                    .font(.caption2)
                            }
                        }
                    
                    AreaMark(x: .value("Year", day.date),
                                 y: .value("Weight", day.weight))
                        .foregroundStyle(linearGradient)
                        .interpolationMethod(.catmullRom)
                               
                    
                }
                .frame(width: chartWidth, height: 300)
            }
           
            
            
          
            .padding()
            .chartXAxis {
                AxisMarks(values: .stride(by: .day, count: spacingCount)) { value in
                    
                    
                    AxisValueLabel {
                        if let label = value.as(Date.self) {
                           
                         
                            Text(transformDate(label))
                                .font(.caption2)
                                .padding([.top, .leading], 10)
                        }
                    }
                    AxisGridLine(centered: true, stroke: StrokeStyle(lineWidth: 0.5))
                        .foregroundStyle(.gray)
                }
            }
                
 
            
            .chartYAxis(.visible)
            .chartYScale(domain: customDomain)
            .chartPlotStyle { plotArea in
                plotArea
                 
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .border(Color.customGreen)
                
            }
         
            
            
        }
        
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .padding(5)
        .shadow( radius: 0.5, x: 0, y: 0.5)
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
