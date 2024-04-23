//
//  FavoriteCocktailsListViewModel.swift
//  CocktailsApp
//
//  Created by Юрий Кручинин on 3/2/24.
//

import Foundation
import Combine

@MainActor
final class FavoriteCocktailsListViewModel: ObservableObject {
    
    @Published var cocktailsAfterCombine: [Cocktail] = []
    @Published var searchText: String = ""
    @Published var sortOption: SortOptions = .none
    var cancellables = Set<AnyCancellable>()
    
    let firestoreManager: FirestoreManager
    let coreDataManager: CoreDataManager
    let combineManager: CombineManager
    
    init(firestoreManager: FirestoreManager, coreDataManager: CoreDataManager, combineManager: CombineManager) {
        self.firestoreManager = firestoreManager
        self.coreDataManager = coreDataManager
        self.combineManager = combineManager
        getFavoriteCocktails()
    }
    
    private func getFavoriteCocktails() {
        firestoreManager.$cocktails
            .receive(on: DispatchQueue.main)
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .combineLatest(coreDataManager.$favoriteCocktails, $searchText, $sortOption)
            .map(filterAndSortFavoriteCocktails)
            .sink { _ in
                print("Completion in getFavoriteCocktails Method")
            } receiveValue: { [weak self] returnedCocktails in
                self?.cocktailsAfterCombine = returnedCocktails
            }
            .store(in: &cancellables)
        
    }
    
    private func filterAndSortFavoriteCocktails(cocktails: [Cocktail], cocktailEntities: [FavoritesEntity], text: String, sortOption: SortOptions) -> [Cocktail] {
        let favoriteCocktails = fetchFavoriteCocktailsFromEntity(cocktails: cocktails, cocktailEntities: cocktailEntities)
        return combineManager.filterAndSortCocktails(text: text, cocktails: favoriteCocktails, sortOption: sortOption)
    }
    
    private func fetchFavoriteCocktailsFromEntity(cocktails: [Cocktail], cocktailEntities: [FavoritesEntity]) -> [Cocktail] {
        let cocktailsToReturn = cocktails.compactMap { cocktail -> Cocktail? in
            guard let entity = cocktailEntities.first(where: { $0.cocktailId == cocktail.id }) else {
                return nil
            }
            return cocktail
        }
        return cocktailsToReturn
    }
}
