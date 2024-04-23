//
//  FavoriteCocktailsListView.swift
//  CocktailsApp
//
//  Created by Юрий Кручинин on 3/2/24.
//

import SwiftUI

struct FavoriteCocktailsListView: View {
    
    @StateObject private var viewModel: FavoriteCocktailsListViewModel
    @State private var detailIsShown: Bool = false
    @State private var selectedCocktail: Cocktail?
    @State private var textFieldText: String = ""
    @State private var showSortView: Bool = false
    
    init(viewModel: FavoriteCocktailsListViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            headerSection
            SearchBarView(placeHolderTitle: "Type a cocktail name...", searchText: $viewModel.searchText)
            if showSortView {
                SortView(sort: $viewModel.sortOption, forCustomCocktail: false)
            }
            cocktailsListSection
        }
        .onAppear {
            print("Core Data Cocktails - \(viewModel.coreDataManager.favoriteCocktails.count)")
            print("Cocktails Afte Combine - \(viewModel.cocktailsAfterCombine.count)")
        }
    }
}

struct FavoriteCocktailsListView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteCocktailsListView(viewModel:
                                    FavoriteCocktailsListViewModel(firestoreManager: FirestoreManager(),
                                                                   coreDataManager: CoreDataManager(),
                                                                   combineManager: CombineManager()))
    }
}

extension FavoriteCocktailsListView {
    
    private var headerSection: some View {
        HStack {
            Spacer()
            Text("Favorite Cocktails")
                .font(.title)
            Spacer()
            ShowSortViewButton(iconName: showSortView ? "chevron.down" : "chevron.up")
                .rotationEffect(Angle(degrees: showSortView ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showSortView.toggle()
                    }
                }
        }
    }
    
    private var cocktailsListSection: some View {
        List {
            ForEach(viewModel.cocktailsAfterCombine) { cocktail in
                CocktailRowView(cocktail: cocktail,
                                iconName: cocktail.isFavorite ? "checkmark" : "plus",
                                coreDataManager: viewModel.coreDataManager,
                                firestoreManager: viewModel.firestoreManager)
                .listRowInsets(.init(top: 5,
                                     leading: 0,
                                     bottom: 5,
                                     trailing: 0))
                .listRowBackground(Color.theme.background)
                .background(
                                    Color.white.opacity(0.001)
                                )
            }
        }
        .listStyle(.plain)
    }
}
