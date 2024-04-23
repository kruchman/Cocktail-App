//
//  Color.swift
//  CocktailsApp
//
//  Created by Юрий Кручинин on 31/1/24.
//

import Foundation
import SwiftUI


extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let sort = Color("SortColor")
    let gold = Color("GoldColor")
    let green = Color("GreenColor")
    let red = Color("RedColor")
    let secondaryText = Color("SecondaryTextColor")
}
