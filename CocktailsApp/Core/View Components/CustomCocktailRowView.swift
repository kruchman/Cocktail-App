//
//  CustomCocktailRowView.swift
//  CocktailsApp
//
//  Created by Юрий Кручинин on 9/3/24.
//

import SwiftUI

struct CustomCocktailRowView: View {
    
    let customCocktail: CustomCocktail
    let viewModel: CustomCocktailsListViewModel
    
    var body: some View {
        HStack(alignment: .top) {
            titleAndImageSection
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    difficultySection
                    methodsSection
                }
                glassSection
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        .frame(height: 180)
        .background(Material.ultraThick)
        .overlay(alignment: .topTrailing) {
                trashButton
        }
    }
}

struct CustomCocktailRowView_Previews: PreviewProvider {
    static var previews: some View {
        CustomCocktailRowView(customCocktail: dev.customCockailTwo,
                              viewModel: CustomCocktailsListViewModel(firestoreManager: FirestoreManager()))
    }
}

extension CustomCocktailRowView {
    
    private var titleAndImageSection: some View {
        VStack(alignment: .leading) {
            Text(customCocktail.title)
                .font(.title2)
                .bold()
                .padding(.top, 10)
            Spacer()
            ImageServiceView(customCocktail: customCocktail)
                .frame(width: 120, height: 120)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.3), radius: 10, y: 10)
                .padding(.bottom, 10)
            Spacer()
        }
        .padding(.trailing, 20)
    }
    
    private var difficultySection: some View {
        VStack {
            Text("Difficulty:")
                .font(.title3)
                .bold()
            switch customCocktail.difficulty {
            case "easy": Text(customCocktail.difficulty)
                    .font(.title3)
                    .foregroundColor(Color.theme.green)
            case "medium": Text(customCocktail.difficulty)
                    .font(.title3)
                    .foregroundColor(Color.theme.gold)
            case "hard": Text(customCocktail.difficulty)
                    .font(.title3)
                    .foregroundColor(Color.theme.red)
            default : Text(customCocktail.difficulty)
            }
        }
        .padding(.vertical, 15)
    }
    
    private var glassSection: some View {
        Image(customCocktail.glassType)
            .resizable()
            .scaledToFill()
            .frame(width: 80, height: 80)
            .clipShape(Circle())
            .shadow(radius: 3)
            .padding(.trailing, 10)
            .offset(y: 30)
    }
    
    private var methodsSection: some View {
        VStack {
            Text("Methods:")
                .font(.title3)
                .bold()
            VStack {
                ForEach(customCocktail.makeMethod, id:\.self) { makeMethod in
                    Text(makeMethod)
                        .font(.caption)
                        .fontWeight(.medium)
                }
            }
        }
        .padding(.bottom, 10)
    }
    
    private var trashButton: some View {
        Image(systemName: "trash")
            .font(.title)
            .frame(width: 50, height: 50)
            .foregroundColor(.red)
            .padding(.horizontal, 20)
            .onTapGesture {
                Task {
                    do {
                        try await viewModel.deleteCustomCocktail(customCocktail: customCocktail)
                    } catch {
                        print("Error deleting custom cocktail: \(customCocktail.title)")
                    }
                }
            }
    }
}
