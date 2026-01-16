//
//  HistoryViewModel.swift
//  MindMirror
//
//  Created by Manav Arya Singh on 2026-01-17.
//

import SwiftUI

class HistoryViewModel: ObservableObject {
    @Published var entries: [Entry] = []
    
    init() {
        loadEntries()
    }
    
    func loadEntries() {
        entries = DataManager.shared.loadEntries().sorted(by: { $0.date > $1.date })
    }
    
    func getWeeklySummary() -> WeeklySummary {
        let calendar = Calendar.current
        let now = Date()
        let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!
        let weekEnd = calendar.date(byAdding: .day, value: 6, to: weekStart)!
        
        let weekEntries = entries.filter { $0.date >= weekStart && $0.date <= weekEnd }
        
        let moodCounts = Dictionary(grouping: weekEntries, by: { $0.mood }).mapValues { $0.count }
        let dominantMood = moodCounts.max(by: { $0.value < $1.value })?.key
        
        let streak = calculateStreak()
        let trend = detectMoodTrend(weekEntries)
        
        let reflection = generateReflection(dominantMood: dominantMood, entryCount: weekEntries.count, trend: trend)
        
        return WeeklySummary(moodCounts: moodCounts, dominantMood: dominantMood, streak: streak, trend: trend, reflection: reflection)
    }
    
    private func detectMoodTrend(_ entries: [Entry]) -> MoodTrend {
        let sortedEntries = entries.sorted(by: { $0.date < $1.date })
        guard sortedEntries.count >= 3 else { return .stable }
        
        // Calculate weighted average sentiment over time
        let sentiments = sortedEntries.compactMap { entry -> Double? in
            guard let mood = entry.mood, let confidence = entry.confidence else { return nil }
            return mood.sentimentValue * confidence
        }
        
        if sentiments.count < 3 { return .stable }
        
        let firstHalf = sentiments.prefix(sentiments.count / 2)
        let secondHalf = sentiments.suffix(sentiments.count / 2)
        
        let firstAvg = firstHalf.reduce(0, +) / Double(firstHalf.count)
        let secondAvg = secondHalf.reduce(0, +) / Double(secondHalf.count)
        
        let difference = secondAvg - firstAvg
        
        if difference > 0.2 { return .improving }
        else if difference < -0.2 { return .declining }
        else { return .stable }
    }
    
    private func generateReflection(dominantMood: Mood?, entryCount: Int, trend: MoodTrend) -> String {
        let moodText = dominantMood?.rawValue.lowercased() ?? "mixed"
        let trendText: String
        
        switch trend {
        case .improving:
            trendText = "and your mood seems to be improving over the week."
        case .declining:
            trendText = "though there might be some challenges emerging."
        case .stable:
            trendText = "with a consistent emotional pattern."
        }
        
        return "This week, you felt mostly \(moodText) across \(entryCount) entries, \(trendText) Remember, every emotion is valid and temporary."
    }
    
    private func calculateStreak() -> Int {
        let calendar = Calendar.current
        var streak = 0
        var currentDate = Date()
        
        while true {
            let hasEntry = entries.contains { calendar.isDate($0.date, inSameDayAs: currentDate) }
            if hasEntry {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
            } else {
                break
            }
        }
        
        return streak
    }
    
    func exportWeeklySummary() -> UIImage? {
        let summaryView = WeeklySummaryExportView(summary: getWeeklySummary())
        let renderer = ImageRenderer(content: summaryView)
        renderer.scale = UIScreen.main.scale
        return renderer.uiImage
    }
}

struct WeeklySummary {
    let moodCounts: [Mood?: Int]
    let dominantMood: Mood?
    let streak: Int
    let trend: MoodTrend
    let reflection: String
}

enum MoodTrend {
    case improving, declining, stable
    
    var description: String {
        switch self {
        case .improving: return "Improving"
        case .declining: return "Declining"
        case .stable: return "Stable"
        }
    }
    
    var color: Color {
        switch self {
        case .improving: return .green
        case .declining: return .red
        case .stable: return .blue
        }
    }
}