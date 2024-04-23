//
//  CompletionCircle.swift
//  CocktailsApp
//
//  Created by Юрий Кручинин on 21/2/24.
//

import SwiftUI

struct CompletionCircle: View {
    
    @State private var animate: Bool = false
    @Binding var stepCompleted: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 1)
                .foregroundColor(Color.theme.secondaryText)
                .frame(width: 27, height: 27)
                .padding(.horizontal)
            
            Circle()
                .fill(stepCompleted ? Color.green : Color.red)
                .frame(width: 20, height: 20)
                .padding(.horizontal)
            
            Circle()
                .stroke(lineWidth: 0.5)
                .fill(stepCompleted ? Color.green : Color.red)
                .frame(width: 20, height: 20)
                .padding(.horizontal)
                .scaleEffect(animate ? 3 : 0, anchor: .center)
                .opacity(animate ? 0 : 1)
        }

        .onChange(of: stepCompleted) { _ in
            doAnAnimation()
        }
    }
}

struct CompletionCircle_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CompletionCircle(stepCompleted: .constant(true))
                .previewLayout(.sizeThatFits)
            
            CompletionCircle(stepCompleted: .constant(false))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}

extension CompletionCircle {
    
    func doAnAnimation() {
            withAnimation(.easeInOut(duration: 0.5)) {
                animate = true
            }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            animate = false 
        }
    }
    
    
}
