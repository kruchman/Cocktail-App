//
//  SearchBarView.swift
//  CocktailsApp
//
//  Created by Юрий Кручинин on 3/2/24.
//

import SwiftUI

struct SearchBarView: View {
    
    var placeHolderTitle: String
    @Binding var searchText: String
    
    var body: some View {
        TextField(placeHolderTitle, text: $searchText)
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .padding(.leading)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(15)
            .padding()
            .overlay(
                Image(systemName: "xmark.circle.fill")
                    .padding()
                    .offset(x: -25)
                    .autocorrectionDisabled()
                    .font(.title2)
                    .frame(width: 40, height: 40)
                    .opacity(searchText.isEmpty ? 0 : 1)
                    .onTapGesture {
                        searchText = ""
                        UIApplication.shared.endEditing()
                    }
                , alignment: .trailing)
            
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(placeHolderTitle: "Type something", searchText: .constant(""))
    }
}

typealias ReusableTextField = SearchBarView
