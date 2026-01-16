//
//  Mood.swift
//  MindMirror
//
//  Created by Manav Arya Singh on 2026-01-17.
//

import SwiftUI

enum Mood: String, CaseIterable, Codable {
    case happy = "Happy"
    case calm = "Calm"
    case neutral = "Neutral"
    case anxious = "Anxious"
    case sad = "Sad"
    case stressed = "Stressed"
    
    var color: Color {
        switch self {
        case .happy: return Color.yellow.opacity(0.8)
        case .calm: return Color.blue.opacity(0.8)
        case .neutral: return Color.gray.opacity(0.8)
        case .anxious: return Color.orange.opacity(0.8)
        case .sad: return Color.purple.opacity(0.8)
        case .stressed: return Color.red.opacity(0.8)
        }
    }
    
    var gradient: Gradient {
        switch self {
        case .happy:
            return Gradient(colors: [Color.yellow.opacity(0.3), Color.orange.opacity(0.3)])
        case .calm:
            return Gradient(colors: [Color.blue.opacity(0.3), Color.cyan.opacity(0.3)])
        case .neutral:
            return Gradient(colors: [Color.gray.opacity(0.3), Color.white.opacity(0.3)])
        case .anxious:
            return Gradient(colors: [Color.orange.opacity(0.3), Color.red.opacity(0.3)])
        case .sad:
            return Gradient(colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.3)])
        case .stressed:
            return Gradient(colors: [Color.red.opacity(0.3), Color.pink.opacity(0.3)])
        }
    }
    
    var icon: String {
        switch self {
        case .happy: return "😊"
        case .calm: return "😌"
        case .neutral: return "😐"
        case .anxious: return "😰"
        case .sad: return "😢"
        case .stressed: return "😫"
        }
    }
}