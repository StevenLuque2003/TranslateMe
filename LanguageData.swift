import Foundation

struct LanguageData: Identifiable {
    let id = UUID()
    let code: String
    let name: String
    let flag: String
}

// Global languages data that can be used throughout the app
struct LanguageManager {
    static let languages: [LanguageData] = [
        LanguageData(code: "en", name: "English", flag: "🇺🇸"),
        LanguageData(code: "es", name: "Spanish", flag: "🇪🇸"),
        LanguageData(code: "fr", name: "French", flag: "🇫🇷"),
        LanguageData(code: "de", name: "German", flag: "🇩🇪"),
        LanguageData(code: "it", name: "Italian", flag: "🇮🇹"),
        LanguageData(code: "ja", name: "Japanese", flag: "🇯🇵"),
        LanguageData(code: "zh", name: "Chinese", flag: "🇨🇳"),
        LanguageData(code: "ru", name: "Russian", flag: "🇷🇺"),
        LanguageData(code: "pt", name: "Portuguese", flag: "🇵🇹"),
        LanguageData(code: "ar", name: "Arabic", flag: "🇸🇦"),
        LanguageData(code: "ko", name: "Korean", flag: "🇰🇷"),
        LanguageData(code: "nl", name: "Dutch", flag: "🇳🇱")
    ]
    
    static func getLanguageName(for code: String) -> String {
        languages.first(where: { $0.code == code })?.name ?? code
    }
    
    static func getLanguageFlag(for code: String) -> String {
        languages.first(where: { $0.code == code })?.flag ?? "🌐"
    }
}
