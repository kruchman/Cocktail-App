//
//  ArrowButton.swift
//  CocktailsApp
//
//  Created by Юрий Кручинин on 25/2/24.
//

import SwiftUI

struct ArrowButton: View {
    
    @State private var animating: Bool = false
    @Binding var goToAnotherView: Bool
    @Binding var allStepsCompleted: Bool
    var viewModel: CustomCocktailsViewModel?
    var iconName: String
    
    var body: some View {
        Button {
            goToAnotherView.toggle()
            if let viewModel {
                viewModel.saveCustomCocktail()
                UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true)
            }
        } label: {
            ZStack {
                Circle()
                    .fill(Color.theme.background)
                Image(systemName: iconName)
                    .font(.headline)
                    .foregroundColor(animating ? Color.green :
                                        Color.theme.accent.opacity(allStepsCompleted ? 1 : 0.2))
                    .shadow(color: allStepsCompleted ? Color.green : Color.theme.accent,
                            radius: animating ? 20 : 0,
                            x: animating ? 5 : 0,
                            y: animating ? 5 : 0)
            }
            .frame(width: 44, height: 44)
            .shadow(color: animating ? Color.green : Color.theme.accent.opacity(0.3),
                    radius: animating ? 15 : 4,
                    x: animating ? 0 : -4,
                    y: 0)
            .onChange(of: allStepsCompleted) { newValue in
                arrowAnimation(allStepsCompleted: newValue)
            }
        }
    }
}

struct ArrowButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ArrowButton(goToAnotherView: .constant(false), allStepsCompleted: .constant(false), iconName: "arrow.right")
                .previewLayout(.sizeThatFits)
            
            ArrowButton(goToAnotherView: .constant(false), allStepsCompleted: .constant(true), iconName: "checkmark")
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}

extension ArrowButton {
    
    func arrowAnimation(allStepsCompleted: Bool) {
        if allStepsCompleted {
            withAnimation(.easeInOut(duration: 0.5)) {
                animating.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    animating.toggle()
                }
            }
        }
    }
    
}
