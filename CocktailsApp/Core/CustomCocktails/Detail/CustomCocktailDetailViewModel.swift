//
//  CustomCocktailDetailViewModel.swift
//  CocktailsApp
//
//  Created by Юрий Кручинин on 26/3/24.
//

import Foundation

@MainActor
final class CustomCocktailDetailViewModel: ObservableObject {
    
    @Published private(set) var ingridients: [Ingridient] = []
    var isLoading: Bool = false
    let customCocktail: CustomCocktail
    
    let firestoreManager: FirestoreManager
    
    init(customCocktail: CustomCocktail, firestoreManager: FirestoreManager) {
        self.customCocktail = customCocktail
        self.firestoreManager = firestoreManager
    }
    
    func getIngridients() async throws {
        isLoading = true
        self.ingridients = try await firestoreManager.getIngridients(for: customCocktail)
        self.ingridients.sort(by: { $0.amount ?? 0 > $1.amount ?? 0 })
        isLoading = false
    }
    
}
