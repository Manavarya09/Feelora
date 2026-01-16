//
//  WeeklySummaryExportView.swift
//  MindMirror
//
//  Created by Manav Arya Singh on 2026-01-17.
//

import SwiftUI

struct WeeklySummaryExportView: View {
    let summary: WeeklySummary
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Weekly Mood Summary")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Generated on \(Date().formattedDate())")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // Mood Distribution Chart
            Chart {
                ForEach(Mood.allCases, id: \.self) { mood in
                    BarMark(
                        x: .value("Mood", mood.rawValue),
                        y: .value("Count", summary.moodCounts[mood] ?? 0)
                    )
                    .foregroundStyle(mood.color)
                }
            }
            .frame(height: 200)
            
            VStack(alignment: .leading, spacing: 10) {
                if let dominant = summary.dominantMood {
                    Text("Dominant Mood: \(dominant.rawValue)")
                        .font(.headline)
                        .foregroundColor(dominant.color)
                }
                
                Text("Current Streak: \(summary.streak) days")
                    .font(.subheadline)
                
                Text(summary.reflection)
                    .font(.body)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding()
        .frame(width: 400, height: 600)
        .background(Color.white)
    }
}