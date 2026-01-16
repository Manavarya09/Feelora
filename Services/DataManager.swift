//
//  DataManager.swift
//  MindMirror
//
//  Created by Manav Arya Singh on 2026-01-17.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    private let entriesKey = "journalEntries"
    
    func saveEntries(_ entries: [Entry]) {
        do {
            let data = try JSONEncoder().encode(entries)
            UserDefaults.standard.set(data, forKey: entriesKey)
        } catch {
            print("Error saving entries: \(error)")
        }
    }
    
    func loadEntries() -> [Entry] {
        guard let data = UserDefaults.standard.data(forKey: entriesKey) else { return [] }
        do {
            return try JSONDecoder().decode([Entry].self, from: data)
        } catch {
            print("Error loading entries: \(error)")
            return []
        }
    }
    
    func getEntryForToday() -> Entry? {
        let entries = loadEntries()
        return entries.first { Calendar.current.isDateInToday($0.date) }
    }
    
    func saveOrUpdateEntry(_ entry: Entry) {
        var entries = loadEntries()
        if let index = entries.firstIndex(where: { Calendar.current.isDateInToday($0.date) }) {
            entries[index] = entry
        } else {
            entries.append(entry)
        }
        saveEntries(entries)
    }
}