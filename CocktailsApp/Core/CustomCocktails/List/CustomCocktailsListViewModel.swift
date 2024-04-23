//
//  CustomCocktailsListViewModel.swift
//  CocktailsApp
//
//  Created by Юрий Кручинин on 4/3/24.
//

import Foundation

@MainActor
final class CustomCocktailsListViewModel: ObservableObject {
    
    @Published var customCocktails: [CustomCocktail] = []
    
    let customCocktailsFolderName: String = "custom_cocktails_images"
    let firestoreManager: FirestoreManager
    let localFileManager = LocalFileManager.shared
    
    init(firestoreManager: FirestoreManager) {
        self.firestoreManager = firestoreManager
        getCustomCocktails()
    }
    
    //MARK: - Getting Methods
    
    func getCustomCocktails() {
        firestoreManager.addListenerForCusomCocktails { [weak self] customCocktails in
            self?.customCocktails = customCocktails
        }
    }
    
    func getIngridientsForCustomCocktail(customCocktail: CustomCocktail) async throws  -> [Ingridient] {
        try await firestoreManager.getIngridients(for: customCocktail)
    }
    
    //MARK: - Deleting Methods
    
    func deleteCustomCocktail(customCocktail: CustomCocktail) async throws {
        deleteImageFromLocalFile(customCocktailId: customCocktail.id)
        try await deleteCustomCocktailFromFirebase(customCocktail: customCocktail)
    }
    
    func deleteCustomCocktailFromFirebase(customCocktail: CustomCocktail) async throws {
        try await firestoreManager.deleteCustomCocktail(customCocktail: customCocktail)
    }
    
    func deleteImageFromLocalFile(customCocktailId: String) {
        localFileManager.deleteImage(imageName: customCocktailId, folderName: customCocktailsFolderName)
    }
    
}
