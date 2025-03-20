import Foundation
import FirebaseFirestore

struct Translation: Identifiable, Codable {
    @DocumentID var id: String?
    let sourceText: String
    let translatedText: String
    let sourceLanguage: String
    let targetLanguage: String
    let timestamp: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case sourceText
        case translatedText
        case sourceLanguage
        case targetLanguage
        case timestamp
    }
}
