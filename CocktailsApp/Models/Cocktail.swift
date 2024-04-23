//
//  Cocktail.swift
//  CocktailsApp
//
//  Created by Юрий Кручинин on 30/1/24.
//

import Foundation

struct Cocktail: Identifiable, Codable {
    let id: String
    let title: String
    let isFavorite: Bool
    let description: String
    let shortDescription: String
    let glassType: String
    let imageUrlString: String?
    let difficulty: String
    let rating: Double
    let makeMethod: [String]
    let ingridients: [Ingridient]
    let history: String
    let preparationDescription: String
    let link: String?
    
    init(id: String, title: String, isFavorite: Bool, description: String, shortDescription: String, glassType: String, imageUrlString: String? = nil, difficulty: String, rating: Double, makeMethod: [String] = [], ingridients: [Ingridient], history: String, preparationDescription: String, link: String) {
        self.id = id
        self.title = title
        self.isFavorite = isFavorite
        self.description = description
        self.shortDescription = shortDescription
        self.glassType = glassType
        self.imageUrlString = imageUrlString
        self.difficulty = difficulty
        self.rating = rating
        self.makeMethod = makeMethod
        self.ingridients = ingridients
        self.history = history
        self.preparationDescription = preparationDescription
        self.link = link
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case isFavorite = "is_favorite"
        case description
        case shortDescription = "short_description"
        case glassType = "glass_type"
        case imageUrlString = "image_url_string"
        case difficulty
        case rating
        case makeMethod = "make_method"
        case ingridients
        case history
        case preparationDescription = "preparation_description"
        case link
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
        self.description = try container.decode(String.self, forKey: .description)
        self.shortDescription = try container.decode(String.self, forKey: .shortDescription)
        self.glassType = try container.decode(String.self, forKey: .glassType)
        self.imageUrlString = try container.decodeIfPresent(String.self, forKey: .imageUrlString)
        self.difficulty = try container.decode(String.self, forKey: .difficulty)
        self.rating = try container.decode(Double.self, forKey: .rating)
        self.makeMethod = try container.decode([String].self, forKey: .makeMethod)
        self.ingridients = try container.decode([Ingridient].self, forKey: .ingridients)
        self.history = try container.decode(String.self, forKey: .history)
        self.preparationDescription = try container.decode(String.self, forKey: .preparationDescription)
        self.link = try container.decode(String.self, forKey: .link)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.isFavorite, forKey: .isFavorite)
        try container.encode(self.description, forKey: .description)
        try container.encode(self.shortDescription, forKey: .shortDescription)
        try container.encode(self.glassType, forKey: .glassType)
        try container.encode(self.imageUrlString, forKey: .imageUrlString)
        try container.encode(self.difficulty, forKey: .difficulty)
        try container.encode(self.rating, forKey: .rating)
        try container.encode(self.makeMethod, forKey: .makeMethod)
        try container.encode(self.ingridients, forKey: .ingridients)
        try container.encode(self.history, forKey: .history)
        try container.encode(self.preparationDescription, forKey: .preparationDescription)
        try container.encode(self.link, forKey: .link)
    }
    
}

