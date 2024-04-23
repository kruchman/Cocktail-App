//
//  CombineManager.swift
//  CocktailsApp
//
//  Created by Юрий Кручинин on 4/2/24.
//

import Foundation

final class CombineManager {
    
    func filterAndSortCocktails(text: String, cocktails: [Cocktail], sortOption: SortOptions) -> [Cocktail] {
        var updatedCocktails = filterSearchText(text: text, cocktails: cocktails)
        sortCocktails(cocktails: &updatedCocktails, sortOption: sortOption)
        return updatedCocktails
    }
    
    func filterSearchText(text: String, cocktails: [Cocktail]) -> [Cocktail] {
        guard !text.isEmpty else { return cocktails }
        let lowercasedText = text.lowercased()
        return cocktails.filter { cocktail -> Bool in
            cocktail.title.lowercased().contains(lowercasedText)
        }
    }
    
    func sortCocktails(cocktails: inout [Cocktail], sortOption: SortOptions) {
        let difficultyOrder: [String: Int] = ["easy": 1, "medium": 2, "hard": 3]
        switch sortOption {
        case .title: return cocktails.sort { $0.title < $1.title }
        case .titleReversed: return cocktails.sort { $0.title > $1.title }
        case .rating: return cocktails.sort { $0.rating > $1.rating }
        case .ratingReversed: return cocktails.sort { $0.rating < $1.rating }
        case .difficulty: return cocktails.sort { difficultyOrder[$0.difficulty] ?? 1 < difficultyOrder[$1.difficulty] ?? 1 }
        case .difficultyReversed: return cocktails.sort { difficultyOrder[$0.difficulty] ?? 1 > difficultyOrder[$1.difficulty] ?? 1 }
        case .none: break
        }
    }
}
