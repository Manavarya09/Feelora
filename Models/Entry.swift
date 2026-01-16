//
//  Entry.swift
//  MindMirror
//
//  Created by Manav Arya Singh on 2026-01-17.
//

import Foundation

struct Entry: Identifiable, Codable {
    var id = UUID()
    var date: Date
    var text: String
    var mood: Mood?
    var confidence: Double?
    
    // Computed property to check if editable (same day)
    var isEditable: Bool {
        Calendar.current.isDateInToday(date)
    }
    
    // For previews
    static let sample = Entry(date: Date(), text: "Today was a good day. I felt happy and productive.", mood: .happy, confidence: 0.8)
}