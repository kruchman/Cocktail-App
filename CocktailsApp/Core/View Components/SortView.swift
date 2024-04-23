//
//  FilterView.swift
//  CocktailsApp
//
//  Created by Юрий Кручинин on 3/2/24.
//

import SwiftUI

struct SortView: View {
    
    let sortOptions: [SortOptions] = [.title, .rating, .difficulty, .none]
    let sortOptionsForCustom: [SortOptions] = [.title, .difficulty, .none]
    @State var selectedSortOption: SortOptions = .none
    @Binding var sort: SortOptions
    @Namespace private var namespace
    var forCustomCocktail: Bool
    
    var body: some View {
        VStack(spacing: 5) {
            Text("Sort By")
                .font(.title2)
                .padding(.top, 10)
            HStack(spacing: 10) {
                ForEach(forCustomCocktail ? sortOptionsForCustom : sortOptions, id: \.self) { option in
                    ZStack {
                        if option == selectedSortOption {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.theme.sort.opacity(0.5))
                                .matchedGeometryEffect(id: "sortBackground", in: namespace)
                        }
                        Text(option.rawValue)
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            sort(option: option)
                        }
                    }
                }
            }
            .padding()
        }
    }
    
    func sort(option: SortOptions) {
        if selectedSortOption  == option {
            switch sort {
            case .title:
                sort = .titleReversed
            case .titleReversed:
                sort = .title
            case .rating:
                sort = .ratingReversed
            case .ratingReversed:
                sort = .rating
            case .difficulty:
                sort = .difficultyReversed
            case .difficultyReversed:
                sort = .difficulty
            case .none:
                sort = .none
            }
        } else {
            sort = option
        }
        selectedSortOption = option
    }
}

struct SortView_Previews: PreviewProvider {
    static var previews: some View {
        SortView(sort: .constant(.none), forCustomCocktail: false)
    }
}
