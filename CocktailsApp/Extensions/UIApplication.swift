//
//  UIApplication.swift
//  CocktailsApp
//
//  Created by Юрий Кручинин on 3/2/24.
//

import Foundation
import SwiftUI

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
