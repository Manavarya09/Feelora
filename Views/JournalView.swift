//
//  JournalView.swift
//  MindMirror
//
//  Created by Manav Arya Singh on 2026-01-17.
//

import SwiftUI

struct JournalView: View {
    @StateObject private var viewModel = JournalViewModel()
    
    var body: some View {
        ZStack {
            AnimatedBackground(mood: viewModel.currentEntry.mood)
            
            VStack(spacing: 20) {
                Text("Today's Reflection")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                ZStack(alignment: .topTrailing) {
                    TextEditor(text: $viewModel.currentEntry.text)
                        .font(.body)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemBackground).opacity(0.9))
                        )
                        .frame(height: 200)
                        .shadow(radius: 2)
                    
                    if viewModel.isAnalyzing {
                        ProgressView()
                            .padding(.trailing, 16)
                            .padding(.top, 16)
                    }
                }
                
                MoodIndicator(mood: viewModel.currentEntry.mood, confidence: viewModel.currentEntry.confidence)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Journal")
        .onDisappear {
            viewModel.saveEntry()
        }
    }
}

struct JournalView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            JournalView()
        }
    }
}