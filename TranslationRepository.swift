// TranslationRepository.swift
import Foundation
import FirebaseFirestore
//import FirebaseFirestoreSwift

class TranslationRepository: ObservableObject {
    private let db = Firestore.firestore()
    private let collectionName = "translations"
    
    @Published var translations: [Translation] = []
    
    init() {
        fetchTranslations()
    }
    
    func fetchTranslations() {
        db.collection(collectionName)
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                self?.translations = documents.compactMap { queryDocumentSnapshot in
                    try? queryDocumentSnapshot.data(as: Translation.self)
                }
            }
    }
    
    func saveTranslation(_ translation: Translation) {
        do {
            _ = try db.collection(collectionName).addDocument(from: translation)
        } catch {
            print("Error saving translation: \(error.localizedDescription)")
        }
    }
    
    func clearHistory() {
        // Get all documents in the collection
        db.collection(collectionName).getDocuments { [weak self] snapshot, error in
            guard let documents = snapshot?.documents else {
                print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // Delete each document
            for document in documents {
                self?.db.collection(self?.collectionName ?? "").document(document.documentID).delete()
            }
        }
    }
}
