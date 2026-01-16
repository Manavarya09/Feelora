//
//  AnimatedBackground.swift
//  MindMirror
//
//  Created by Manav Arya Singh on 2026-01-17.
//

import SwiftUI

struct AnimatedBackground: View {
    let mood: Mood?
    
    @State private var breathingPhase = 0.0
    @State private var floatingOffset: CGFloat = 0.0
    
    var body: some View {
        ZStack {
            if let mood = mood {
                // Gradient background with subtle breathing
                LinearGradient(gradient: mood.gradient, startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                    .opacity(0.8 + 0.2 * sin(breathingPhase))
                    .animation(.easeInOut(duration: mood.breathingDuration).repeatForever(autoreverses: true), value: breathingPhase)
                
                // Floating shapes with physics-based motion
                GeometryReader { geometry in
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(mood.color.opacity(0.15))
                            .frame(width: 80 + CGFloat(index * 30), height: 80 + CGFloat(index * 30))
                            .offset(
                                x: sin(breathingPhase + Double(index) * .pi / 3) * geometry.size.width * 0.08,
                                y: cos(breathingPhase + Double(index) * .pi / 3) * geometry.size.height * 0.08 + floatingOffset
                            )
                            .animation(
                                Animation.spring(response: mood.springResponse, dampingFraction: mood.dampingFraction)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(index) * 0.5),
                                value: breathingPhase
                            )
                    }
                }
            } else {
                // Default neutral background
                Color.gray.opacity(0.05)
                    .ignoresSafeArea()
            }
        }
        .onAppear {
            startBreathingAnimation()
        }
        .onChange(of: mood) { _ in
            // Smooth transition when mood changes
            withAnimation(.spring(response: 1.0, dampingFraction: 0.8)) {
                floatingOffset = CGFloat.random(in: -10...10)
            }
        }
        .accessibilityHidden(true) // Background animations are decorative
        .prefersDefaultColorScheme() // Respect system appearance
    }
    
    private func startBreathingAnimation() {
        if UIAccessibility.isReduceMotionEnabled {
            // No animation for reduced motion
            return
        }
        withAnimation(.easeInOut(duration: mood?.breathingDuration ?? 4.0).repeatForever(autoreverses: true)) {
            breathingPhase = .pi * 2
        }
    }
}

struct AnimatedBackground_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedBackground(mood: .happy)
    }
}