//
//  CoreDataManager.swift
//  CocktailsApp
//
//  Created by Юрий Кручинин on 4/2/24.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    private let container: NSPersistentContainer
    private let containerName: String = "CocktailContainer"
    private let favoritesEntity: String = "FavoritesEntity"
    
    @Published var favoriteCocktails: [FavoritesEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error {
                print("Error loading persistent stores: \(error)")
            }
            self.getFavoriteCocktails()
        }
    }
    
    //MARK: - Favorites
    
    func updateFavorites(cocktail: Cocktail) {
        if let entity = favoriteCocktails.first(where: { $0.cocktailId == cocktail.id }) {
            remove(entity: entity)
            print("Cocktail has been removed from favorites")
        } else {
            addCocktailToFavorites(cocktail: cocktail)
            print("Cocktail has been added to favorites")
        }
    }
    
    private func getFavoriteCocktails() {
        let request = NSFetchRequest<FavoritesEntity>(entityName: favoritesEntity)
        do {
            favoriteCocktails = try container.viewContext.fetch(request)
        } catch {
            print("Error fetching from FavoritesEntity: \(error)")
        }
    }
    
    private func addCocktailToFavorites(cocktail: Cocktail) {
        let entity = FavoritesEntity(context: container.viewContext)
        entity.cocktailId = cocktail.id
        applyChangesToFavorites()
    }
    
    
    private func remove(entity: FavoritesEntity) {
        container.viewContext.delete(entity)
        applyChangesToFavorites()
    }
    
    private func applyChangesToFavorites() {
        save()
        getFavoriteCocktails()
    }
    
    //MARK: - Common
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch {
            print("Error saving to Core Data: \(error)")
        }
    }
    
}
