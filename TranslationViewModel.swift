import Foundation
import Combine

class TranslationViewModel: ObservableObject {
    private let translationService = TranslationService()
    private let repository = TranslationRepository()
    
    @Published var sourceText = ""
    @Published var translatedText = ""
    @Published var isTranslating = false
    @Published var errorMessage: String?
    
    @Published var sourceLanguage = "en" // Default source language (English)
    @Published var targetLanguage = "es" // Default target language (Spanish)
    
    var translations: [Translation] {
        repository.translations
    }
    
    func translate() async {
        guard !sourceText.isEmpty else { return }
        
        isTranslating = true
        errorMessage = nil
        
        do {
            let result = try await translationService.translate(
                text: sourceText,
                from: sourceLanguage,
                to: targetLanguage
            )
            
            await MainActor.run {
                self.translatedText = result
                self.saveTranslation()
                self.isTranslating = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Translation failed: \(error.localizedDescription)"
                self.isTranslating = false
            }
        }
    }
    
    private func saveTranslation() {
        let translation = Translation(
            sourceText: sourceText,
            translatedText: translatedText,
            sourceLanguage: sourceLanguage,
            targetLanguage: targetLanguage,
            timestamp: Date()
        )
        
        repository.saveTranslation(translation)
    }
    
    func clearHistory() {
        repository.clearHistory()
    }
}
