//
//  ImageServiceView.swift
//  CocktailsApp
//
//  Created by Юрий Кручинин on 3/2/24.
//

import SwiftUI

struct ImageServiceView: View {
    
    @StateObject private var viewModel: ImagesServiceViewModel
    let cocktail: Cocktail?
    let ingridient: Ingridient?
    let customCocktail: CustomCocktail?
    
    init(cocktail: Cocktail? = nil, ingridient: Ingridient? = nil, customCocktail: CustomCocktail? = nil) {
        self.cocktail = cocktail
        self.ingridient = ingridient
        self.customCocktail = customCocktail
        self._viewModel = StateObject(wrappedValue: ImagesServiceViewModel(cocktail: cocktail,
                                                                           ingridient: ingridient,
                                                                           customCocktail: customCocktail))
    }
    
    var body: some View {
        if let image = viewModel.image {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
        } else {
            ProgressView()
        }
    }
}

struct ImageServiceView_Previews: PreviewProvider {
    static var previews: some View {
        ImageServiceView(cocktail: dev.cocktail)
    }
}
