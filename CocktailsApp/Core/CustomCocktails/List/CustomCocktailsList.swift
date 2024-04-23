//
//  CustomCocktailsList.swift
//  CocktailsApp
//
//  Created by Юрий Кручинин on 4/3/24.
//

import SwiftUI

struct CustomCocktailsList: View {
    
    @StateObject private var viewModel: CustomCocktailsListViewModel
    @State private var showSortView: Bool = false
    @State private var detailIsShown: Bool = false
    @State private var selectedCustomCocktail: CustomCocktail?
    @State private var creationSheetPoped: Bool = false
    
    init(viewModel: CustomCocktailsListViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack {
                    creationButton
                    Spacer()
                    Text("Custom Cocktails")
                        .font(.title)
                    Spacer()
                }
                customCocktailsList
            }
            .sheet(isPresented: $creationSheetPoped, content: {
                NameAndImageView()
            })
            if let selectedCustomCocktail, detailIsShown {
                CustomCocktailDetailView(cocktail: selectedCustomCocktail,
                                         firestoreManager: viewModel.firestoreManager,
                                         detailIsShown: $detailIsShown)
                .zIndex(1)
                .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity),
                                        removal: .move(edge: .leading).combined(with: .opacity)))
            }
        }
    }
}

struct CustomCocktailsList_Previews: PreviewProvider {
    static var previews: some View {
        CustomCocktailsList(viewModel: CustomCocktailsListViewModel(firestoreManager: FirestoreManager()))
    }
}

extension CustomCocktailsList {
    
    private var creationButton: some View {
        Button {
            creationSheetPoped.toggle()
        } label: {
            Image(systemName: "plus")
                .font(.headline)
                .foregroundColor(Color.theme.accent)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(Color.theme.background)
                )
                .shadow(color: Color.theme.accent.opacity(0.3),
                        radius: 10)
                .padding(15)
        }
    }

    private var customCocktailsList: some View {
        List {
            ForEach(viewModel.customCocktails) { cocktail in
                CustomCocktailRowView(customCocktail: cocktail,
                                      viewModel: viewModel)
                .listRowInsets(.init(top: 5,
                                     leading: 0,
                                     bottom: 5,
                                     trailing: 0))
                .listRowBackground(Color.theme.background)
                .background(
                    Color.white.opacity(0.001)
                )
                .onTapGesture {
                    selectedCustomCocktail = cocktail
                    withAnimation(.easeInOut(duration: 0.2)) {
                        detailIsShown.toggle()
                    }
                }
            }
        }
        .listStyle(.plain)
    }

}
