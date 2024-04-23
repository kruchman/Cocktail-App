//
//  MakeMethods.swift
//  CocktailsApp
//
//  Created by Юрий Кручинин on 24/2/24.
//

import SwiftUI

struct MakeMethods: View {
    let makeMethods: [String] = ["shake", "build", "stir", "muddle", "blend", "layers"]
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 10, alignment: .center),
        GridItem(.flexible(), spacing: 10, alignment: .center),
        GridItem(.flexible(), spacing: 10, alignment: .center)
    ]
    @Binding var selectedMethods: [String]
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(makeMethods, id: \.self) { method in
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
//                        .frame(width: 30, height: 2)
                        .foregroundColor(Color.theme.green.opacity(0.7))
//                        .offset(y: 15)
                        .opacity(selectedMethods.contains(method) ? 1 : 0)
                    Text(method)
                        .font(.headline)
                        .padding()
                        .cornerRadius(15)
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                addOrRemoveMethod(method: method)
                            }
                        }
                }
            }
        }
        .padding()
    }
    func addOrRemoveMethod(method: String) {
        if selectedMethods.contains(method) {
            selectedMethods.removeAll { $0 == method }
        } else {
            selectedMethods.append(method)
        }
    }
}

struct MakeMethods_Previews: PreviewProvider {
    static var previews: some View {
        MakeMethods(selectedMethods: .constant([]))
    }
}
