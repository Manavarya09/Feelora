//
//  JournalViewModel.swift
//  MindMirror
//
//  Created by Manav Arya Singh on 2026-01-17.
//

import SwiftUI
import Combine

class JournalViewModel: ObservableObject {
    @Published var currentEntry: Entry
    @Published var isAnalyzing = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        if let existingEntry = DataManager.shared.getEntryForToday() {
            self.currentEntry = existingEntry
        } else {
            self.currentEntry = Entry(date: Date(), text: "")
        }
        
        // Auto-analyze when text changes
        $currentEntry
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink { [weak self] entry in
                self?.analyzeMood(for: entry)
            }
            .store(in: &cancellables)
    }
    
    func analyzeMood(for entry: Entry) {
        guard !entry.text.isEmpty else {
            currentEntry.mood = nil
            currentEntry.confidence = nil
            return
        }
        
        isAnalyzing = true
        
        // Perform analysis on background thread
        DispatchQueue.global(qos: .userInitiated).async {
            let (mood, confidence) = MoodAnalyzer.analyze(text: entry.text)
            DispatchQueue.main.async {
                self.currentEntry.mood = mood
                self.currentEntry.confidence = confidence
                self.isAnalyzing = false
                self.saveEntry()
            }
        }
    }
    
    func saveEntry() {
        DataManager.shared.saveOrUpdateEntry(currentEntry)
    }
    
    func updateText(_ text: String) {
        currentEntry.text = text
    }
}