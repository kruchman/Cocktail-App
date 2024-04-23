//
//  RootView.swift
//  CocktailsApp
//
//  Created by Юрий Кручинин on 1/2/24.
//

import SwiftUI

struct RootView: View {
    
    let firestoreManager: FirestoreManager
    let coreDataManager: CoreDataManager
    let combineManager: CombineManager
    
    init(firestoreManager: FirestoreManager,
         coreDataManager: CoreDataManager,
         combineManager: CombineManager) {
        self.firestoreManager = firestoreManager
        self.coreDataManager = coreDataManager
        self.combineManager = combineManager
    }
    
    var body: some View {
        TabView {
            ClassicCocktailsListView(viewModel:
                                        ClassicCocktailsListViewModel(firestoreManager: firestoreManager,
                                                                      coreDataManager: coreDataManager,
                                                                      combineManager: combineManager))
            .tabItem {
                Image(systemName: "wineglass")
            }
            FavoriteCocktailsListView(viewModel:
                                        FavoriteCocktailsListViewModel(firestoreManager: firestoreManager,
                                                                       coreDataManager: coreDataManager,
                                                                       combineManager: combineManager))
            .tabItem {
                Image(systemName: "heart")
            }
            CustomCocktailsList(viewModel: CustomCocktailsListViewModel(firestoreManager: firestoreManager))
            .tabItem {
                Image(systemName: "lightbulb")
            }
        }
        .tint(Color.theme.accent)
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(firestoreManager: FirestoreManager(),
                 coreDataManager: CoreDataManager(),
                 combineManager: CombineManager())
    }
}
