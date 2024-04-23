//
//  PreviewProvider.swift
//  CocktailsApp
//
//  Created by Юрий Кручинин on 31/1/24.
//

import Foundation
import SwiftUI

extension PreviewProvider {
    
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
}

class DeveloperPreview {
    
    static let instance = DeveloperPreview()
    private init() { }
    
    let cocktail: Cocktail = Cocktail(id: UUID().uuidString,
                                      title: "White Russian",
                                      isFavorite: true,
                                      description: "The White Russian is a delicious, creamy treat of a drink. It tastes like a chocolate mocha with cream, so what’s not to love? It’s like a coffee drink with a kick.",
                                      shortDescription: "The White Russian is a delicious, creamy treat of a drink. It tastes like a chocolate mocha with cream, so what’s not to love? It’s like a coffee drink with a kick.",
                                      glassType: "old_fashion",
                                      imageUrlString: "https://www.liquor.com/thmb/wzgqg2FC1Sqbwo_PAJofVVZIMRk=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/__opt__aboutcom__coeus__resources__content_migration__liquor__2017__12__20073201__white-russian-720x720-article-cbe4b9a832c64f8da0bb09407caefa7f.jpg",
                                      difficulty: "easy",
                                      rating: 3.9,
                                      makeMethod: ["build"],
                                      ingridients: [Ingridient(id: "34c28r6TSfyVjlZ8UoOG", title: "coffe liqour", amount: 30, imageUrlString: "https://sf.flatiron-wines.com/cdn/shop/products/Bottle-of-Kahlua-Coffee-Liqueur-Spirits-Flatiron-SF_f6a66a60-9119-41fb-b23e-b698a0c5b5c6_grande.png?v=1681769206"),
                                                   Ingridient(id: "9THP7AO4Vymj3o5o7mtA", title: "vodka", amount: 30, imageUrlString: "https://mezclaloencasa.com/wp-content/uploads/2020/04/Absolut-Vodka-1000ml-Front-Standard-White-Background-HR.jpg"),
                                                   Ingridient(id: "Pvb6vBMV07pvgKJbvZQt", title: "cream", amount: 30, imageUrlString: "https://www.simplyrecipes.com/thmb/za_8EBSznn5Bl-oL1BDR4EiVpQY=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/Simply-Recipes-Cold-Brew-Coffee-LEAD-10-370e9962821a496886677f1b7dbcdce5.jpg")],
                                      history: " In 1949, the story goes that Tops created the Black Russian—a White Russian sans cream—at the Hotel Metropole in Brussels to honor Perle Mesta, then U.S. ambassador to Luxembourg. Somewhere in the 1950s, when sweet, milky drinks were in their heyday, the cream was added and the White Russian was born. It’s been said the name “Russian” comes from its base spirit of vodka, just like the Moscow Mule. (Originally, all vodka that was exported to the States came from Russia.)",
                                      preparationDescription: "Add the vodka and Kahlúa to a rocks glass filled with ice. Top with the heavy cream and stir.",
                                      link: "https://www.liquor.com/recipes/white-russian/")
    
    let customCocktailOne: CustomCocktail = CustomCocktail(id: UUID().uuidString,
                                                        title: "Otvertka",
                                                        glassType: "old_fashion",
                                                        difficulty: "easy",
                                                        makeMethod: ["build"],
                                                        ingridients: [Ingridient(id: "9THP7AO4Vymj3o5o7mtA", title: "vodka", amount: 30, imageUrlString: "https://mezclaloencasa.com/wp-content/uploads/2020/04/Absolut-Vodka-1000ml-Front-Standard-White-Background-HR.jpg"),
                                                                     Ingridient(id: "LLiN3cMaVSFIGHGzKB7e", title: "ice", imageUrlString: "https://www.bluedot-water.com/wp-content/uploads/2014/08/Dollarphotoclub_67481050.jpg"),
                                                                     Ingridient(id: "prRyvAhDZQ1HJBXrTlfA", title: "Orange", imageUrlString: "https://www.saberhealth.com/uploaded/blog/images/Oranges.jpg")])
    let customCockailTwo: CustomCocktail = CustomCocktail(id: UUID().uuidString,
                                                          title: "Johny Bravo",
                                                          glassType: "wine_glass",
                                                          difficulty: "medium",
                                                          makeMethod: ["shake", "build"],
                                                          ingridients: [
                                                          Ingridient(id: "LLiN3cMaVSFIGHGzKB7e", title: "ice",imageUrlString: "https://www.bluedot-water.com/wp-content/uploads/2014/08/Dollarphotoclub_67481050.jpg"),
                                                          Ingridient(id: "a6tli7RaEWNQmmsL5QqP", title: "soda", amount: 100, imageUrlString: "https://marksandspencerfood.gr/wp-content/uploads/2023/09/29258840-768x768.jpg"),
                                                          Ingridient(id: "dCWT3BHcSRuBOGidNUr3", title: "mint", imageUrlString: "https://myjam.co.uk/cdn/shop/products/fresh-mint.jpg?v=1643309678"),
                                                          Ingridient(id: "iFyXxgPdVRrAPyu2EomC", title: "lemon juice", amount: 20, imageUrlString: "https://www.evolvingtable.com/wp-content/uploads/2023/02/Lemons-juice-8.jpg"),
                                                          Ingridient(id: "mnfIJMCywgg8dC1hzlqw", title: "aperol", amount: 50, imageUrlString: "https://www.carluccios.com/wp-content/uploads/2018/08/Aperol_SQ_RESIZE__15057.1652991874.1280.1280.jpg"),
                                                          Ingridient(id: "zTbCYoJxPW91vIp6EDEm", title: "white rum", amount: 30, imageUrlString: "https://m.media-amazon.com/images/I/715QvM63DIL.jpg"),
                                                          Ingridient(id: "cmkV6FJtDBoIVS0TkI9T", title: "black rum", amount: 30, imageUrlString: "https://cdn.diffords.com/contrib/bws/2021/12/61ab67a4eff07.jpg")
                                                          ])
}
