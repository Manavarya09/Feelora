//
//  AnimatedBackground.swift
//  MindMirror
//
//  Created by Manav Arya Singh on 2026-01-17.
//

import SwiftUI

struct AnimatedBackground: View {
    let mood: Mood?
    
    @State private var phase = 0.0
    
    var body: some View {
        ZStack {
            if let mood = mood {
                // Gradient background
                LinearGradient(gradient: mood.gradient, startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                // Animated shapes
                GeometryReader { geometry in
                    ForEach(0..<5) { index in
                        Circle()
                            .fill(mood.color.opacity(0.1))
                            .frame(width: 100 + CGFloat(index * 20), height: 100 + CGFloat(index * 20))
                            .offset(
                                x: sin(phase + Double(index)) * geometry.size.width * 0.1,
                                y: cos(phase + Double(index)) * geometry.size.height * 0.1
                            )
                            .animation(
                                Animation.easeInOut(duration: 3 + Double(index))
                                    .repeatForever(autoreverses: true),
                                value: phase
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
            withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                phase = .pi * 2
            }
        }
    }
}

struct AnimatedBackground_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedBackground(mood: .happy)
    }
}