//
//  CocktailDetailViewModel.swift
//  CocktailsApp
//
//  Created by Юрий Кручинин on 31/1/24.
//

import Foundation


@MainActor
final class CocktailDetailViewModel: ObservableObject {
    
    @Published private(set) var ingridients: [Ingridient] = []
    var isLoading: Bool = false
    let cocktail: Cocktail
    
    let firestoreManager: FirestoreManager
    
    init(cocktail: Cocktail, firestoreManager: FirestoreManager) {
        self.cocktail = cocktail
        self.firestoreManager = firestoreManager
    }
    
    func getIngridients() async throws {
        isLoading = true
        self.ingridients = try await firestoreManager.getIngridients(for: cocktail)
        isLoading = false 
    }
}
