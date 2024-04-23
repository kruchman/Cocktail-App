//
//  ClassicCocktailsListViewModel.swift
//  CocktailsApp
//
//  Created by Юрий Кручинин on 30/1/24.
//

import Foundation
import Combine

@MainActor
final class ClassicCocktailsListViewModel: ObservableObject {
    
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
        addSubscribers()
    }

    private func addSubscribers() {
        $searchText
            .receive(on: DispatchQueue.main)
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .combineLatest(firestoreManager.$cocktails, $sortOption)
            .map(combineManager.filterAndSortCocktails)
            .sink { _ in
                print("Error while filtering the cocktails list")
            } receiveValue: { [weak self] cocktails in
                self?.cocktailsAfterCombine = cocktails
            }
            .store(in: &cancellables)
    }
    
}
