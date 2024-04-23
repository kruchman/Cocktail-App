//
//  Ingridient.swift
//  CocktailsApp
//
//  Created by Юрий Кручинин on 31/1/24.
//

import Foundation

struct Ingridient: Codable, Identifiable, Equatable {
    let id: String
    let title: String?
    let amount: Int?
    let imageUrlString: String?
    
    init(id: String, title: String? = nil, amount: Int? = nil, imageUrlString: String? = nil) {
        self.id = id
        self.title = title
        self.amount = amount
        self.imageUrlString = imageUrlString
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "ingridient_id"
        case title
        case amount
        case imageUrlString = "image_url_string"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.amount = try container.decodeIfPresent(Int.self, forKey: .amount)
        self.imageUrlString = try container.decodeIfPresent(String.self, forKey: .imageUrlString)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.amount, forKey: .amount)
        try container.encode(self.imageUrlString, forKey: .imageUrlString)
    }
}
