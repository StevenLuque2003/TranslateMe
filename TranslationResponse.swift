import Foundation

struct TranslationResponse: Codable {
    let responseData: ResponseData
    let quotaFinished: Bool?
    let mtLangSupported: Bool?
    let responseDetails: String?
    let responseStatus: Int?
    let responderId: Int?
    let exception_code: Int?
    
    enum CodingKeys: String, CodingKey {
        case responseData
        case quotaFinished
        case mtLangSupported
        case responseDetails
        case responseStatus
        case responderId
        case exception_code
    }
}

struct ResponseData: Codable {
    let translatedText: String
    let match: Double?
}
