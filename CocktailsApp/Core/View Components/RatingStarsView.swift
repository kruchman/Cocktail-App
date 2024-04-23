//
//  RatingStarsView.swift
//  CocktailsApp
//
//  Created by Юрий Кручинин on 31/1/24.
//

import SwiftUI

struct RatingStarsView: View {
    
    @State var raiting: Double
    
    var body: some View {
        ZStack {
            starsView
                .shadow(color: Color.theme.accent.opacity(0.25),
                        radius: 10)
                .overlay(overlayView.mask(starsView))
        }
    }
}

struct RatingStarsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RatingStarsView(raiting: 3.9)
                .previewLayout(.sizeThatFits)
            
            RatingStarsView(raiting: 3.9)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}

extension RatingStarsView {
    private var starsView: some View {
        HStack(spacing: 0) {
            ForEach(1..<6) { index in
                Image(systemName: "star.fill")
                    .font(.headline)
                    .foregroundColor(raiting >= Double(index) ? Color.theme.gold : Color.theme.secondaryText)
            }
        }
    }
    private var overlayView: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(.yellow)
                    .frame(width: geometry.size.width * CGFloat(raiting) / 5)
            }
        }
        .allowsHitTesting(false)
    }
}
