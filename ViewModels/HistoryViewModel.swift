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
        
        let reflection = generateReflection(dominantMood: dominantMood, entryCount: weekEntries.count)
        
        return WeeklySummary(moodCounts: moodCounts, dominantMood: dominantMood, streak: streak, reflection: reflection)
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
    let reflection: String
}