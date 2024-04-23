//
//  CocktailRowView.swift
//  CocktailsApp
//
//  Created by Юрий Кручинин on 31/1/24.
//

import SwiftUI

struct CocktailRowView: View {
    
    let cocktail: Cocktail
    let iconName: String
    let coreDataManager: CoreDataManager
    let firestoreManager: FirestoreManager
    
    init(cocktail: Cocktail, iconName: String, coreDataManager: CoreDataManager, firestoreManager: FirestoreManager) {
        self.cocktail = cocktail
        self.iconName = iconName
        self.coreDataManager = coreDataManager
        self.firestoreManager = firestoreManager
    }
    
    var body: some View {
        HStack {
            cocktailImageSection
            Spacer()
            cocktailCharacteristicsSection
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        .frame(height: 180)
        .background(Material.ultraThick)
        .overlay(alignment: .topTrailing) {
            AddOrRemoveFavoriteCocktailButtonView(cocktail: cocktail,
                             iconName: cocktail.isFavorite ? "checkmark" : "plus",
                             coreDataManger: coreDataManager,
                             firestoreManager: firestoreManager)
        }
    }
}

struct CocktailRowView_Previews: PreviewProvider {
    static var previews: some View {
        CocktailRowView(cocktail: dev.cocktail, iconName: "plus", coreDataManager: CoreDataManager(), firestoreManager: FirestoreManager())
    }
}

extension CocktailRowView {
    
    private var cocktailImageSection: some View {
        VStack {
            Text(cocktail.title)
                .font(.title3)
                .bold()
            ImageServiceView(cocktail: cocktail)
                .frame(width: 120, height: 120)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.3), radius: 10, y: 10)
        }
    }
    
    private var cocktailCharacteristicsSection: some View {
        VStack(alignment: .leading) {
            RatingStarsView(raiting: cocktail.rating)
            HStack {
                Text("Difficulty:")
                    .font(.callout)
                    .bold()
                switch cocktail.difficulty {
                case "easy": Text(cocktail.difficulty)
                        .font(.headline)
                        .foregroundColor(Color.theme.green)
                case "medium": Text(cocktail.difficulty)
                        .font(.headline)
                        .foregroundColor(Color.theme.gold)
                case "hard": Text(cocktail.difficulty)
                        .font(.headline)
                        .foregroundColor(Color.theme.red)
                default : Text(cocktail.difficulty)
                }
            }
                Text("Description:")
                    .font(.footnote)
                    .bold()
                Text(cocktail.shortDescription)
                    .font(.caption2)
        }
    }
}
