//
//  SortOptions.swift
//  CocktailsApp
//
//  Created by Юрий Кручинин on 3/2/24.
//

import Foundation

enum SortOptions: String, CaseIterable {
    case title
    case titleReversed
    case rating
    case ratingReversed
    case difficulty
    case difficultyReversed
    case none
}
