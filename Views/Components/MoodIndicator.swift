//
//  MoodIndicator.swift
//  MindMirror
//
//  Created by Manav Arya Singh on 2026-01-17.
//

import SwiftUI

struct MoodIndicator: View {
    let mood: Mood?
    let confidence: Double?
    
    var body: some View {
        VStack(spacing: 8) {
            if let mood = mood {
                Text(mood.icon)
                    .font(.system(size: 40))
                    .accessibilityHidden(true) // Icon is decorative
                
                Text(mood.rawValue)
                    .font(.headline)
                    .foregroundColor(mood.color)
                
                if let confidence = confidence {
                    Text("Confidence: \(Int(confidence * 100))%")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            } else {
                Text("🤔")
                    .font(.system(size: 40))
                    .accessibilityHidden(true)
                
                Text("Analyzing...")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground).opacity(0.8))
                .shadow(radius: 4)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityValue(accessibilityValue)
    }
    
    private var accessibilityLabel: String {
        if let mood = mood {
            return "Current mood is \(mood.rawValue)"
        } else {
            return "Analyzing mood"
        }
    }
    
    private var accessibilityValue: String {
        if let confidence = confidence {
            return "Confidence \(Int(confidence * 100)) percent"
        } else {
            return ""
        }
    }
}

struct MoodIndicator_Previews: PreviewProvider {
    static var previews: some View {
        MoodIndicator(mood: .happy, confidence: 0.8)
    }
}