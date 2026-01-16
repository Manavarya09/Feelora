//
//  ContentView.swift
//  MindMirror
//
//  Created by Manav Arya Singh on 2026-01-17.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some View {
        if hasCompletedOnboarding {
            MainTabView()
        } else {
            OnboardingView()
        }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            JournalView()
                .tabItem {
                    Label("Journal", systemImage: "book")
                }
            
            MoodHistoryView()
                .tabItem {
                    Label("History", systemImage: "chart.bar")
                }
            
            PrivacyView()
                .tabItem {
                    Label("Privacy", systemImage: "hand.raised")
                }
        }
    }
}

struct PrivacyView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Your Privacy Matters")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("🔒 **All Data Stays on Your Device**")
                        .font(.headline)
                    
                    Text("Your journal entries and mood analysis never leave your phone. We don't collect, store, or share any of your personal data.")
                    
                    Text("🧠 **On-Device AI Processing**")
                        .font(.headline)
                    
                    Text("Mood analysis happens locally using Apple's Natural Language framework. No internet connection required.")
                    
                    Text("📱 **No Accounts or Sign-ups**")
                        .font(.headline)
                    
                    Text("Use MindMirror without creating any accounts. Your data is stored securely in your device's local storage.")
                    
                    Text("🎯 **Privacy by Design**")
                        .font(.headline)
                    
                    Text("Built with privacy-first principles from the ground up. Your thoughts and feelings are yours alone.")
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemBackground))
                        .shadow(radius: 2)
                )
                .padding(.horizontal)
            }
            .padding(.top, 40)
        }
        .navigationTitle("Privacy")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}