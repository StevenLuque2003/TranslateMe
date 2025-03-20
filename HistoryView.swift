// HistoryView.swift
import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: TranslationViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.blue.opacity(0.05).ignoresSafeArea()
                
                VStack {
                    if viewModel.translations.isEmpty {
                        ContentUnavailableView(
                            "No Translation History",
                            systemImage: "globe",
                            description: Text("Your translated phrases will appear here")
                        )
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 15) {
                                ForEach(viewModel.translations) { translation in
                                    TranslationHistoryRow(translation: translation)
                                        .background(Color.white)
                                        .cornerRadius(12)
                                        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
                                        .padding(.horizontal)
                                }
                            }
                            .padding(.vertical)
                        }
                    }
                }
            }
            .navigationTitle("Translation History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Clear") {
                        if !viewModel.translations.isEmpty {
                            showingAlert = true
                        }
                    }
                    .foregroundColor(!viewModel.translations.isEmpty ? .red : .gray)
                    .disabled(viewModel.translations.isEmpty)
                }
            }
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Clear History"),
                    message: Text("Are you sure you want to clear all translation history? This action cannot be undone."),
                    primaryButton: .destructive(Text("Clear")) {
                        viewModel.clearHistory()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}
