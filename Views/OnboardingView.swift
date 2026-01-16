//
//  OnboardingView.swift
//  MindMirror
//
//  Created by Manav Arya Singh on 2026-01-17.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    let pages = [
        OnboardingPage(
            title: "Welcome to MindMirror",
            subtitle: "Your private space for emotional reflection",
            description: "Write daily thoughts and watch your mood come alive through gentle, on-device analysis.",
            icon: "📖"
        ),
        OnboardingPage(
            title: "Completely Private",
            subtitle: "Your data never leaves your device",
            description: "All mood analysis happens locally. No accounts, no cloud, no tracking. Just you and your thoughts.",
            icon: "🔒"
        ),
        OnboardingPage(
            title: "Emotional Intelligence",
            subtitle: "Visual mood reflections",
            description: "See your emotions through calming colors and subtle animations that adapt to how you're feeling.",
            icon: "🌈"
        )
    ]
    
    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()
            
            VStack {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                
                Spacer()
                
                Button(action: nextAction) {
                    Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                .padding(.bottom, 50)
            }
        }
    }
    
    private func nextAction() {
        if currentPage < pages.count - 1 {
            withAnimation {
                currentPage += 1
            }
        } else {
            hasCompletedOnboarding = true
        }
    }
}

struct OnboardingPage {
    let title: String
    let subtitle: String
    let description: String
    let icon: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Text(page.icon)
                .font(.system(size: 80))
            
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text(page.subtitle)
                    .font(.title2)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}