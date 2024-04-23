//
//  FirestorageManager.swift
//  CocktailsApp
//
//  Created by Юрий Кручинин on 30/1/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreManager {
    
    @Published private(set) var cocktails: [Cocktail] = []
    
    private let cocktailsCollection: CollectionReference = Firestore.firestore().collection("cocktails")
    private let ingridientsCollection: CollectionReference = Firestore.firestore().collection("ingridients")
    private let customCocktailsCollection: CollectionReference = Firestore.firestore().collection("custom_cocktails")
    
    init() {
        Task {
            do {
                try await getCocktails()
            } catch {
                print("Error getting cocktails: \(error)")
            }
        }
    }
    
    //MARK: - Cocktails Methods
    
    func getCocktails() async throws {
        let querySnapshot = try await cocktailsCollection.getDocuments()
        let documetns = querySnapshot.documents
        try await MainActor.run {
            cocktails = try documetns.compactMap({ try $0.data(as: Cocktail.self) })
        }
    }
    
    func updateIsFavorite(cocktail: Cocktail) async throws {
        try await cocktailsCollection.document(cocktail.id).updateData([Cocktail.CodingKeys.isFavorite.rawValue : !cocktail.isFavorite])
        try await getCocktails()
    }
    
    //MARK: - Ingridietns Methods
    
    func getIngridients() async throws -> [Ingridient] {
        let querySnapshot = try await ingridientsCollection.getDocuments()
        let documetns = querySnapshot.documents
        return try documetns.compactMap({ try $0.data(as: Ingridient.self) })
    }
    
    func getIngridients(for cocktail: Cocktail) async throws -> [Ingridient] {
        var ingridients = [Ingridient]()
        for ingridient in cocktail.ingridients {
            let ingridientToAppend = try await getIngridientById(ingridientId: ingridient.id, amount: ingridient.amount ?? 0)
            ingridients.append(ingridientToAppend)
        }
        return ingridients
    }
    
    func getIngridients(for cocktail: CustomCocktail) async throws -> [Ingridient] {
        var ingridients = [Ingridient]()
        for ingridient in cocktail.ingridients {
            let ingridientToAppend = try await getIngridientById(ingridientId: ingridient.id, amount: ingridient.amount ?? 0)
            ingridients.append(ingridientToAppend)
        }
        return ingridients
    }
    
    func getIngridientById(ingridientId: String, amount: Int) async throws -> Ingridient {
        let returnedIngridient = try await ingridientsCollection.document(ingridientId).getDocument(as: Ingridient.self)
        let ingridient = Ingridient(id: returnedIngridient.id,
                                    title: returnedIngridient.title ?? "",
                                    amount: amount,
                                    imageUrlString: returnedIngridient.imageUrlString ?? "")
        return ingridient
    }
    
    //MARK: - Custom Cocktails Methods
    
    func getCustomCocktails() async throws -> [CustomCocktail] {
        let querySnapshot = try await customCocktailsCollection.getDocuments()
        let documetns = querySnapshot.documents
        return try documetns.compactMap({ try $0.data(as: CustomCocktail.self) })
    }
    
    func addListenerForCusomCocktails(completion: @escaping ([CustomCocktail]) -> ()) {
        customCocktailsCollection.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No documents in custom cocktails collection")
                return
            }
            let customCocktails: [CustomCocktail] = documents.compactMap { try? $0.data(as: CustomCocktail.self )}
            completion(customCocktails)
        }
    }
    
    func saveCustomCocktail(customCocktail: CustomCocktail) throws {
        try customCocktailsCollection.document(customCocktail.id).setData(from: customCocktail)
    }
    
    func deleteCustomCocktail(customCocktail: CustomCocktail) async throws {
        try await customCocktailsCollection.document(customCocktail.id).delete()
    }
}
