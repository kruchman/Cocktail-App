//
//  TestView.swift
//  CocktailsApp
//
//  Created by Юрий Кручинин on 31/1/24.
//

import SwiftUI

struct TestView: View {
    
    var body: some View {
        ZStack {
            Button {
                
            } label: {
                Text("OK")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(width: 200, height: 60)
                    .background()
                    .cornerRadius(25)
                    .shadow(radius: 20)
            }
            
        }
        .frame(width: 350, height: 500)
        .background()
        .cornerRadius(25)
        .shadow(radius: 10)
        
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}

