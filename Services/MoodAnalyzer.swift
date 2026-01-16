//
//  MoodAnalyzer.swift
//  MindMirror
//
//  Created by Manav Arya Singh on 2026-01-17.
//

import NaturalLanguage

class MoodAnalyzer {
    static func analyze(text: String) -> (Mood, Double) {
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = text
        
        // Get sentiment score for the entire text
        let (sentiment, _) = tagger.tag(at: text.startIndex, unit: .paragraph, scheme: .sentimentScore)
        let score = Double(sentiment?.rawValue ?? "0") ?? 0
        
        // Normalize score to 0-1 for confidence
        let confidence = min(abs(score), 1.0)
        
        // Map sentiment score to mood
        let mood = mapSentimentToMood(score)
        
        return (mood, confidence)
    }
    
    private static func mapSentimentToMood(_ score: Double) -> Mood {
        // Score ranges from -1 (very negative) to 1 (very positive)
        switch score {
        case 0.5...1.0:
            return .happy
        case 0.1..<0.5:
            return .calm
        case -0.1..<0.1:
            return .neutral
        case -0.5..< -0.1:
            return .anxious
        case -1.0..< -0.5:
            return .sad
        default:
            return .stressed // For extreme cases
        }
    }
}