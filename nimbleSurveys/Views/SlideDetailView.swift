//
//  SlideDetailView.swift
//  nimbleSurveys
//
//  Created by Felicitas Figueroa Fagalde on 03/11/2023.
//

import SwiftUI

struct SlideDetailView: View {
    let slide: SlideData
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(slide.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .edgesIgnoringSafeArea(.all)
                
                LinearGradient(gradient: Gradient(colors: [Color.black.opacity(1), Color.black.opacity(0)]), startPoint: .bottom, endPoint: .top)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .leading, spacing: 20) {
                    Text(slide.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 20)
                        .foregroundColor(.white)
                    
                    Text(slide.description)
                        .font(.body)
                        .lineLimit(nil)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        Button(action: {}) {
                            Text("Start Survey")
                                .font(.headline)
                                .foregroundColor(.black)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                        }
                        .padding(.trailing, 20)
                    }
                }
                .padding([.leading, .trailing], 20)
            }
        }
    }
}

#Preview {
    SlideDetailView(slide: slides[0])
}

