//
//  ClassicCocktailsListView.swift
//  CocktailsApp
//
//  Created by Юрий Кручинин on 30/1/24.
//

import SwiftUI

struct ClassicCocktailsListView: View {
    
    @StateObject private var viewModel: ClassicCocktailsListViewModel
    @State private var detailIsShown: Bool = false
    @State private var selectedCocktail: Cocktail?
    @State private var textFieldText: String = ""
    @State private var showSortView: Bool = false
    
    init(viewModel: ClassicCocktailsListViewModel) {
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
        .sheet(isPresented: $detailIsShown) {
            DetailLoadingView(cocktail: $selectedCocktail, firestoreManager: viewModel.firestoreManager)
        }
    }
}

struct ClassicCocktailsListView_Previews: PreviewProvider {
    static var previews: some View {
        ClassicCocktailsListView(viewModel:
                                    ClassicCocktailsListViewModel(firestoreManager: FirestoreManager(),
                                                                  coreDataManager: CoreDataManager(),
                                                                  combineManager: CombineManager()))
    }
}

extension ClassicCocktailsListView {
    
    private var headerSection: some View {
        HStack {
            Spacer()
            Text("Classic Cocktails")
                .font(.title)
            Spacer()
            ShowSortViewButton(iconName: "chevron.down")
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
                                .onTapGesture {
                                    segue(cocktail: cocktail)
                                }
            }
        }
        .listStyle(.plain)
    }
    
    func segue(cocktail: Cocktail) {
        selectedCocktail = cocktail
        detailIsShown.toggle()
    }
}
