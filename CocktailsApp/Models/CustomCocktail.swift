//
//  CustomCocktail.swift
//  CocktailsApp
//
//  Created by Юрий Кручинин on 21/2/24.
//

import Foundation

struct CustomCocktail: Identifiable, Codable {
    let id: String
    let title: String
    let glassType: String
    let difficulty: String
    let makeMethod: [String]
    let ingridients: [Ingridient]
    
    init(id: String, title: String, glassType: String, difficulty: String, makeMethod: [String], ingridients: [Ingridient]) {
        self.id = id
        self.title = title
        self.glassType = glassType
        self.difficulty = difficulty
        self.makeMethod = makeMethod
        self.ingridients = ingridients
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case glassType = "glass_type"
        case difficulty
        case makeMethod = "make_method"
        case ingridients
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.glassType = try container.decode(String.self, forKey: .glassType)
        self.difficulty = try container.decode(String.self, forKey: .difficulty)
        self.makeMethod = try container.decode([String].self, forKey: .makeMethod)
        self.ingridients = try container.decode([Ingridient].self, forKey: .ingridients)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.glassType, forKey: .glassType)
        try container.encode(self.difficulty, forKey: .difficulty)
        try container.encode(self.makeMethod, forKey: .makeMethod)
        try container.encode(self.ingridients, forKey: .ingridients)
    }
}


