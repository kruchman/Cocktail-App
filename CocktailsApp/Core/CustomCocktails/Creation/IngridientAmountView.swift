//
//  IngridientAmountView.swift
//  CocktailsApp
//
//  Created by Юрий Кручинин on 27/2/24.
//

import SwiftUI

struct IngridientAmountView: View {
    
    var ingridient: Ingridient
    @State var textFieldText: String = ""
    @Binding var amountViewIsPresented: Bool
    @ObservedObject var viewModel: CustomCocktailsViewModel
    
    var body: some View {
        VStack {
            VStack {
                ImageServiceView(ingridient: ingridient)
                    .frame(width: 200, height: 200)
                    .cornerRadius(25)
                    .shadow(color: Color.black.opacity(0.3), radius: 3, y: 3)
                Text(ingridient.title ?? "")
                    .font(.title2)
                    .fontWeight(.heavy)
            }
            
            ReusableTextField(placeHolderTitle: "Type an amount...", searchText: $textFieldText)
                .frame(width: 230)
                .keyboardType(.decimalPad)
            
            Button {
                addAnIngridientToAnArray(ingridient: ingridient)
                withAnimation(.easeInOut.speed(2)) {
                    amountViewIsPresented.toggle()
                }
            } label: {
                Text("Add")
                    .font(.headline)
                    .frame(width: 250)
                    .frame(height: 55)
                    .foregroundColor(Color.theme.accent)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(25)
                    .padding(.horizontal)
                    .shadow(color: Color.black.opacity(0.3), radius: 3, y: 3)
            }

        }
        .padding()
        .background(Material.ultraThin)
        .cornerRadius(15)
        .overlay(
            Image(systemName: "xmark")
                .font(.title2)
                .padding(3)
                .padding()
                .onTapGesture {
                    withAnimation(.easeInOut.speed(2)) {
                        amountViewIsPresented.toggle()
                    }
                }
            , alignment: .topLeading
        )
    }
    func addAnIngridientToAnArray(ingridient: Ingridient) {
        guard !textFieldText.isEmpty, let amount: Int = Int(textFieldText) else {
            return
        }
        let ingridientToAdd = Ingridient(id: ingridient.id, title: ingridient.title, amount: amount)
        viewModel.selectedIngridients.append(ingridientToAdd)
        viewModel.selectedIngridients.sort { $0.title ?? "" < $1.title ?? "" }
    }
}

struct IngridientAmountView_Previews: PreviewProvider {
    static var previews: some View {
        IngridientAmountView(ingridient: dev.cocktail.ingridients[0],
                             amountViewIsPresented: .constant(false),
                             viewModel: CustomCocktailsViewModel(firestoreManager: FirestoreManager(),
                                                                 coreDataManager: CoreDataManager()))
    }
}
