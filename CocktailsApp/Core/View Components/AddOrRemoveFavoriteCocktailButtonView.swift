//
//  CircleButtonView.swift
//  CocktailsApp
//
//  Created by Юрий Кручинин on 1/2/24.
//

import SwiftUI

struct AddOrRemoveFavoriteCocktailButtonView: View {
    
    @State private var cocktailIsFavorite: Bool = false
    @State private var animate: Bool = false
    
    let cocktail: Cocktail
    let iconName: String
    let coreDataManger: CoreDataManager
    let firestoreManager: FirestoreManager
    
    init(cocktail: Cocktail, iconName: String, coreDataManger: CoreDataManager, firestoreManager: FirestoreManager) {
        self.cocktail = cocktail
        self.iconName = iconName
        self.coreDataManger = coreDataManger
        self.firestoreManager = firestoreManager
    }
    
    var body: some View {
        image
        .onTapGesture {
            buttonTapped()
        }
        .onAppear {
            cocktailIsFavorite = cocktail.isFavorite
        }
    }
}

struct AddOrRemoveFavoriteButtonView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AddOrRemoveFavoriteCocktailButtonView(cocktail: dev.cocktail, iconName: "checkmark", coreDataManger: CoreDataManager(), firestoreManager: FirestoreManager())
                .previewLayout(.sizeThatFits)
            
            AddOrRemoveFavoriteCocktailButtonView(cocktail: dev.cocktail, iconName: "plus", coreDataManger: CoreDataManager(), firestoreManager: FirestoreManager())
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}

extension AddOrRemoveFavoriteCocktailButtonView {
    
    private var image: some View {
        Image(systemName: cocktailIsFavorite ? "checkmark" : "plus")
        .font(.headline)
        .foregroundColor(animate ? (cocktailIsFavorite ? Color.green : Color.red) : Color.theme.accent)
        .frame(width: 40, height: 40)
        .shadow(color: cocktailIsFavorite ? Color.green : Color.red,
                radius: animate ? 20 : 0,
                x: animate ? 5 : 0,
                y: animate ? 5 : 0)
        .background(
        Circle()
            .fill(Color.theme.background)
        )
        .shadow(color: Color.theme.accent.opacity(0.3),
                radius: 10)
        .padding(15)
        .rotationEffect(Angle(degrees: cocktailIsFavorite ? 0 : 180))
    }
    
    func buttonTapped() {
        Task {
            do {
                try await firestoreManager.updateIsFavorite(cocktail: cocktail)
            } catch {
                print("Error updating isFavorite for cocktail: \(cocktail), error: \(error)")
            }
        }
        withAnimation(.easeInOut(duration: 1)) {
            animate.toggle()
        }
        withAnimation(.easeInOut.delay(0.2)) {
            cocktailIsFavorite.toggle()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    animate.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        coreDataManger.updateFavorites(cocktail: cocktail)
                    }
                }
        }
    }
}
