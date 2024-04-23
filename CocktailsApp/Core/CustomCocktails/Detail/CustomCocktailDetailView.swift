//
//  CustomCocktailDetailView.swift
//  CocktailsApp
//
//  Created by Юрий Кручинин on 26/3/24.
//

import SwiftUI

struct CustomCocktailDetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: CustomCocktailDetailViewModel
    @Binding var detailIsShown: Bool
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 6, alignment: .top),
        GridItem(.flexible(), spacing: 6, alignment: .top),
        GridItem(.flexible(), spacing: 6, alignment: .top)
    ]
    
    init(cocktail: CustomCocktail, firestoreManager: FirestoreManager, detailIsShown: Binding<Bool>) {
        self._viewModel = StateObject(wrappedValue: CustomCocktailDetailViewModel(customCocktail: cocktail,
                                                                                  firestoreManager: firestoreManager))
        self._detailIsShown = Binding(projectedValue: detailIsShown)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                customCocktailImage
                VStack(alignment: .leading) {
                    customCocktailTitle
                    Divider()
                    ingridientsText
                    ingridientsSection
                }
                Divider()
                glassTypeSection
            }
        }
        .frame(width: 350, height: 500)
        .cornerRadius(15)
        .background(.ultraThinMaterial)
        .overlay(alignment: .topTrailing) {
            xmarkButton
        }
        .task {
            do {
                try await viewModel.getIngridients()
            } catch {
                print("Error while getting ingridients: \(error)")
            }
        }
    }
}

struct CustomCocktailDetailView_Previews: PreviewProvider {

    static var previews: some View {
        CustomCocktailDetailView(cocktail: dev.customCockailTwo,
                                 firestoreManager: FirestoreManager(),
                                 detailIsShown: .constant(true))
    }
}

extension CustomCocktailDetailView {
    
    private var customCocktailImage: some View {
        ImageServiceView(customCocktail: viewModel.customCocktail)
            .shadow(radius: 10, y: 10)
    }
    
    private var customCocktailTitle: some View {
            Text(viewModel.customCocktail.title)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.top, 20)
                .padding(.horizontal)
    }
    
    private var ingridientsText: some View {
        Text("Ingridients:")
            .font(.title)
            .fontWeight(.medium)
            .padding(.horizontal)
    }
    
    private var ingridientsSection: some View {
        LazyVGrid(columns: columns, alignment: .center, spacing: 10) {
            ForEach(viewModel.ingridients) { ingridient in
                VStack {
                    ImageServiceView(ingridient: ingridient)
                        .frame(width: 80, height: 80)
                        .clipped()
                        .cornerRadius(20)
                        .shadow(radius: 10, y: 10)
                    
                    HStack {
                        VStack {
                            Text(ingridient.title ?? "")
                                .font(.callout)
                            if let amount = ingridient.amount {
                                Text(String(amount))
                                    .font(.caption)
                                    .foregroundColor(Color.theme.secondaryText)
                                Text("ml/gr")
                                    .font(.caption)
                                    .foregroundColor(Color.theme.secondaryText)
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
    }
    
    private var glassTypeSection: some View {
        VStack {
            Text("Glass Type")
                .font(.headline)
            
            Image(viewModel.customCocktail.glassType)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipped()
                .cornerRadius(20)
                .shadow(radius: 10, y: 10)
        }
    }
    
    private var xmarkButton: some View {
        ZStack {
            Circle()
                .fill(.ultraThinMaterial)
                .frame(width: 50, height: 50)
            Image(systemName: "xmark")
                .font(.title)
        }
        .padding()
        .onTapGesture {
            withAnimation(.easeInOut) {
                detailIsShown.toggle()
            }
        }
    }
}
