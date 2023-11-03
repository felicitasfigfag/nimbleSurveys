//
//  SlideViewContainer.swift
//  nimbleSurveys
//
//  Created by Felicitas Figueroa Fagalde on 03/11/2023.
//

import SwiftUI

struct SlideViewContainer: View {
    @State private var currentSlideIndex = 0
    var currentDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM dd"
        return formatter.string(from: Date()).uppercased()
    }
    
    func nextSlide() {
        withAnimation {
            if currentSlideIndex < slides.count - 1 {
                currentSlideIndex += 1
            } else {
                currentSlideIndex = 0
            }
        }
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(currentDate)
                        Text("Today")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    .padding(.leading, 5)
                    .foregroundColor(.white)
                    Spacer()
                    Image("profilePic")
                        .resizable()
                        .frame(width: 40, height: 40)
                }
                .padding(.horizontal, 24)
                .padding(.top, 60)
                          
                Spacer(minLength: 20)
                
                TabView(selection: $currentSlideIndex) {
                    ForEach(slides.indices, id: \.self) { index in
                        NavigationLink(destination: SlideDetailView(slide: slides[index])) {
                            VStack(alignment: .leading, spacing: 0) {
                                SlideViewItem(title: slides[index].title,
                                              description: slides[index].description,
                                              imageName: slides[index].imageName,
                                              action: nextSlide)
                            }
                            .frame(width: geometry.size.width, height: geometry.size.height - 88, alignment: .leading)
                            .background(Color.red)
                        }
                        .tag(index)
                    }
                }


                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            }
            .background(
                Image(slides[currentSlideIndex].imageName)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            )
            .edgesIgnoringSafeArea(.all)
        }
    }
}

#Preview {
    SlideViewContainer()
}
