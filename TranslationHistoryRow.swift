// TranslationHistoryRow.swift
import SwiftUI

struct TranslationHistoryRow: View {
    let translation: Translation
    @State private var isExpanded = false
    @State private var isCopied = false
    
    // Format the date
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: translation.timestamp)
    }
    
    // Get readable language names
    private func languageName(code: String) -> String {
        let languages = [
            "en": "English",
            "es": "Spanish",
            "fr": "French",
            "de": "German",
            "it": "Italian",
            "ja": "Japanese",
            "zh": "Chinese",
            "ru": "Russian",
            "pt": "Portuguese",
            "ar": "Arabic",
            "ko": "Korean",
            "nl": "Dutch"
        ]
        
        return languages[code] ?? code
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("\(languageName(code: translation.sourceLanguage)) → \(languageName(code: translation.targetLanguage))")
                    .font(.caption)
                    .padding(5)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(4)
                
                Spacer()
                
                Text(formattedDate)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 8) {
                Text(translation.sourceText)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .lineLimit(isExpanded ? nil : 2)
                
                Text(translation.translatedText)
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .lineLimit(isExpanded ? nil : 2)
            }
            
            HStack {
                Button(action: {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }) {
                    Text(isExpanded ? "Show Less" : "Show More")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                Button(action: {
                    UIPasteboard.general.string = translation.translatedText
                    withAnimation {
                        isCopied = true
                    }
                    
                    // Reset the copied status after 2 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            isCopied = false
                        }
                    }
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: isCopied ? "checkmark" : "doc.on.doc")
                        Text(isCopied ? "Copied" : "Copy")
                            .font(.caption)
                    }
                    .foregroundColor(isCopied ? .green : .blue)
                }
            }
        }
        .padding()
    }
}
