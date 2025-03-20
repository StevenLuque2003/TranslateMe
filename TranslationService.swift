import Foundation

class TranslationService {
    // MyMemory API endpoint
    private let baseURL = "https://api.mymemory.translated.net/get"
    
    func translate(text: String, from sourceLanguage: String, to targetLanguage: String) async throws -> String {
        // Build URL with query parameters
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "q", value: text),
            URLQueryItem(name: "langpair", value: "\(sourceLanguage)|\(targetLanguage)")
        ]
        
        guard let url = components?.url else {
            throw URLError(.badURL)
        }
        
        // Make API request
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        // Parse response
        let decoder = JSONDecoder()
        let result = try decoder.decode(TranslationResponse.self, from: data)
        
        return result.responseData.translatedText
    }
}
