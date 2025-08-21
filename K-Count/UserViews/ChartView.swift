//
//  ChartView.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2025/07/06.
//

import SwiftUI
import Charts

struct ChartView: View {
    @AppStorage("userSettings") var userSettings = UserSettings()
    var days: [Day]
    
    var body: some View {
        VStack {
            
            
            
            
            // Display the chart of the last week
            
            Chart(days.suffix(15)) {
                
                LineMark(x: .value("Year", $0.formattedChartDate),
                         y: .value("Weight", $0.weight))
                
                PointMark(x: .value("Year", $0.formattedChartDate),
                          y: .value("Weight", $0.weight))
                
            }
            
            
            .frame(height: 300)
            .padding()
            .chartXAxis {
                // The value is the data you use for your x-axis.
                // We use the formattedDate
                AxisMarks { value in
                    
                    AxisValueLabel {
                        
                        if let label = value.as(String.self) {
                            
                            Text(label)
                                .padding(.top, 10)
                                .rotationEffect(.degrees(-35))
                        }
                    }
                    AxisGridLine(centered: true, stroke: StrokeStyle(lineWidth: 0.5)).foregroundStyle(.gray)
                    
                    
                }
                
                
            }
            
            
            .chartYScale(domain: userSettings.weight-5 ... userSettings.weight + 5)
            .chartPlotStyle { plotArea in
                plotArea
                    .background(.mint.opacity(0.03))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .border(Color.customGreen)
                
            }
            
            
        }
        
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding()
        .shadow( radius: 2, x: 0, y: 1)
    }
}

#Preview {
    ChartView(days: Day.examples)
}
