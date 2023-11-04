//
//  SlideContainerView.swift
//  nimbleSurveys
//
//  Created by Felicitas Figueroa Fagalde on 03/11/2023.
//

import SwiftUI

struct SlideContainerView: View {
    @StateObject var vm: SlideContainerViewModel

    var body: some View {
        GeometryReader { geometry in
                HStack {
                    VStack(alignment: .leading) {
                        Text(vm.currentDate)
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
                
                TabView(selection: $vm.currentSlideIndex) {
                    ForEach(vm.slides.indices, id: \.self) { index in
                        NavigationLink(destination: SlideDetailView(slide: vm.slides[index])) {
                            VStack(alignment: .leading, spacing: 0) {
                                SlideItemView(title: vm.slides[index].title,
                                              description: vm.slides[index].description,
                                              imageName: vm.slides[index].imageName,
                                              action: vm.nextSlide)
                            }
                            .frame(width: geometry.size.width, height: geometry.size.height - 88, alignment: .leading)
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            }
            .background(
                Image(vm.slides[vm.currentSlideIndex].imageName)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            )
            .edgesIgnoringSafeArea(.all)
        }
}

#Preview {
    SlideContainerView(vm: SlideContainerViewModel(slides: mockSlides))
}
