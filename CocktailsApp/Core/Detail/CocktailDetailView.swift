//
//  CocktailDetailView.swift
//  CocktailsApp
//
//  Created by Юрий Кручинин on 31/1/24.
//

import SwiftUI

struct DetailLoadingView: View {
    
    @Binding var cocktail: Cocktail?
    let firestoreManager: FirestoreManager
    
    var body: some View {
        ZStack {
            if let cocktail {
                CocktailDetailView(cocktail: cocktail, firestoreManager: firestoreManager)
            }
        }
    }
}

struct CocktailDetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: CocktailDetailViewModel
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 6, alignment: .top),
        GridItem(.flexible(), spacing: 6, alignment: .top),
        GridItem(.flexible(), spacing: 6, alignment: .top)
    ]
    
    init(cocktail: Cocktail, firestoreManager: FirestoreManager) {
        self._viewModel = StateObject(wrappedValue: CocktailDetailViewModel(cocktail: cocktail, firestoreManager: firestoreManager))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                image
                titleSection
                Divider()
                ingridientsSection
                Divider()
                historyAndYoutubeLinkSection
            }
        }
        .ignoresSafeArea()
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

struct CocktailDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CocktailDetailView(cocktail: dev.cocktail, firestoreManager: FirestoreManager())
    }
}

extension CocktailDetailView {
    
    private var image: some View {
        ImageServiceView(cocktail: viewModel.cocktail)
            .shadow(radius: 10, y: 10)
    }
    
    private var titleSection: some View {
        HStack {
            Text(viewModel.cocktail.title)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.top, 20)
                .padding(.horizontal)
            
            Spacer()
            
            Image(viewModel.cocktail.glassType)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipped()
                .cornerRadius(20)
                .shadow(radius: 10, y: 10)
        }
        .padding(.horizontal)
    }
    
    private var ingridientsSection: some View {
        VStack(alignment: .leading) {
            Text("Ingridients:")
                .font(.title)
                .fontWeight(.medium)
                .padding(.horizontal)
            
            
            LazyVGrid(columns: columns, alignment: .center, spacing: 10) {
                ForEach(viewModel.ingridients) { ingridient in
                    VStack {
                        ImageServiceView(ingridient: ingridient)
                            .frame(width: 100, height: 100)
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
    }
    
    private var historyAndYoutubeLinkSection: some View {
        VStack(alignment: .leading) {
            Text("History:")
                .font(.title)
                .fontWeight(.medium)
                .padding(.horizontal)
            
            Text(viewModel.cocktail.history)
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
                .padding(.horizontal)
            Divider()
            if let url = URL(string: viewModel.cocktail.link ?? "") {
                Link(destination: url) {
                    HStack {
                        Text("Whatch on Youtube")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding(.horizontal)
                        
                        Image("Youtube_logo")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40)
                    }
                    .padding(.bottom, 40)
                }
            }
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
            dismiss()
        }
    }
}
