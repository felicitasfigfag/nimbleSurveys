//
//  SlideViewItem.swift
//  nimbleSurveys
//
//  Created by Felicitas Figueroa Fagalde on 03/11/2023.
//

import SwiftUI

struct SlideItemView: View {
    var title: String
    var description: String
    var imageName: String
    var action: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            VStack (alignment: .leading) {
                Spacer()
                HStack {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(self.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(0)
                            
                        Text(self.description)
                            .foregroundColor(.white)
                            .padding(0)
                    }
                    .frame(width: geometry.size.width * 0.7)
                    .foregroundColor(.white)
                    .padding()
                    .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 5)
                    
                    Button(action: {
                        self.action()
                    }) {
                        Text(">")
                            .font(.largeTitle)
                            .foregroundColor(.black)
                            .frame(width: 56, height: 56)
                            .background(Color.white)
                            .clipShape(Circle())
                    }
                }
                .padding(.bottom, 30)
            }
        }
    }
}
#Preview {
    SlideItemView(title: "Test title", description: "We would like to know how you feel about our work from home...", imageName: "slideBkg2", action: {print("next slide")})
}
