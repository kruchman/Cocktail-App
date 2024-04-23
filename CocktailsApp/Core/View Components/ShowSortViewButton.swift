//
//  CircleShowSortViewButton.swift
//  CocktailsApp
//
//  Created by Юрий Кручинин on 4/2/24.
//

import SwiftUI

struct ShowSortViewButton: View {
    
    let iconName: String
    
        var body: some View {
            Image(systemName: iconName)
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

struct ShowSortViewButton_Previews: PreviewProvider {
    static var previews: some View {
        ShowSortViewButton(iconName: "chevron.up")
    }
}
