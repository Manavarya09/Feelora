//
//  MoodHistoryView.swift
//  MindMirror
//
//  Created by Manav Arya Singh on 2026-01-17.
//

import SwiftUI
import Charts

struct MoodHistoryView: View {
    @StateObject private var viewModel = HistoryViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Mood History")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top)
                    
                    // Weekly Summary
                    WeeklySummaryView(summary: viewModel.getWeeklySummary())
                    
                    // Mood Timeline
                    VStack(alignment: .leading) {
                        Text("Recent Entries")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                        
                        ForEach(viewModel.entries.prefix(7)) { entry in
                            EntryRow(entry: entry)
                        }
                    }
                }
            }
            .navigationTitle("History")
            .onAppear {
                viewModel.loadEntries()
            }
        }
    }
}

struct EntryRow: View {
    let entry: Entry
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(entry.date, style: .date)
                    .font(.headline)
                Text(entry.text.prefix(50) + (entry.text.count > 50 ? "..." : ""))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            if let mood = entry.mood {
                VStack {
                    Text(mood.icon)
                    Text(mood.rawValue)
                        .font(.caption)
                        .foregroundColor(mood.color)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(radius: 2)
        )
        .padding(.horizontal)
    }
}

struct WeeklySummaryView: View {
    let summary: WeeklySummary
    @StateObject private var viewModel = HistoryViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("This Week")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button(action: exportSummary) {
                    Label("Export", systemImage: "square.and.arrow.up")
                }
                .buttonStyle(.bordered)
            }
            
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
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(radius: 2)
            )
            
            HStack {
                VStack(alignment: .leading) {
                    if let dominant = summary.dominantMood {
                        Text("Dominant Mood: \(dominant.rawValue)")
                            .font(.headline)
                            .foregroundColor(dominant.color)
                    }
                    
                    Text("Current Streak: \(summary.streak) days")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("Trend: \(summary.trend.description)")
                        .font(.subheadline)
                        .foregroundColor(summary.trend.color)
                }
                
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(radius: 2)
            )
            
            Text(summary.reflection)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemBackground))
                        .shadow(radius: 2)
                )
        }
        .padding(.horizontal)
    }
    
    private func exportSummary() {
        if let image = viewModel.exportWeeklySummary() {
            // Share the image
            let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            
            // Get the current window scene
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController?.present(activityVC, animated: true)
            }
        }
    }
}

struct MoodHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        MoodHistoryView()
    }
}