//
//  CustomCocktailsViewModel.swift
//  CocktailsApp
//
//  Created by Юрий Кручинин on 20/2/24.
//

import Foundation
import SwiftUI
import PhotosUI


@MainActor
final class CustomCocktailsViewModel: ObservableObject {
    
    @Published var ingridients: [Ingridient] = []
    @Published var selectedIngridients: [Ingridient] = []
    @Published var customCocktailImage: UIImage?
    @Published var selectedMethods: [String] = []
    @Published var selectedGlassType: String?
    var customCocktailtitle: String?
    var difficulty: String?
    
    let firestoreManager: FirestoreManager
    let customCocktailsFolderName: String = "custom_cocktails_images"
    
    let coreDataManager: CoreDataManager
    let fileManager = LocalFileManager.shared
    
    init(firestoreManager: FirestoreManager, coreDataManager: CoreDataManager) {
        self.firestoreManager = firestoreManager
        self.coreDataManager = coreDataManager
        Task {
            do {
                self.ingridients = try await firestoreManager.getIngridients()
                ingridients.sort { $0.title ?? "" < $1.title ?? "" }
            } catch {
                print("Error getting ingridients while initializing the CustomCocktailsViewModel")
            }
        }
        print("CustomCocktailsViewModel Initialized!")
    }
    
    func saveCocktailImage(item: PhotosPickerItem) {
        Task {
            guard let data = try await item.loadTransferable(type: Data.self) else {
                print("Couldnt convert image into a Data")
                return
            }
            customCocktailImage = UIImage(data: data)
        }
    }
    
    func saveCustomCocktailImage(image: UIImage, cocktailId: String) {
        self.fileManager.saveImage(image: image, imageName: cocktailId, folderName: customCocktailsFolderName)
    }
    
    func saveCustomCocktail() {
        if let customCocktailtitle, let difficulty, let selectedGlassType, let customCocktailImage {
            let customCocktailId = UUID().uuidString
            saveCustomCocktailImage(image: customCocktailImage, cocktailId: customCocktailId)
            let customCocktail = CustomCocktail(id: customCocktailId,
                                                title: customCocktailtitle,
                                                glassType: selectedGlassType,
                                                difficulty: difficulty,
                                                makeMethod: selectedMethods,
                                                ingridients: selectedIngridients)
            do {
                try firestoreManager.saveCustomCocktail(customCocktail: customCocktail)
            } catch {
                print("Error saving custom cocktail - \(customCocktailtitle)")
            }
        }
    }
    
}
