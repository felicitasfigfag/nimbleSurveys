//
//  SlideContainerViewModel.swift
//  nimbleSurveys
//
//  Created by Felicitas Figueroa Fagalde on 04/11/2023.
//

import Foundation
import SwiftUI

class SlideContainerViewModel: ObservableObject {
    @Published var currentSlideIndex = 0
    private var dateFormatter = DateFormatter()

    var slides: [SlideData]

    init(slides: [SlideData]) {
        self.slides = slides
        dateFormatter.dateFormat = "EEEE, MMMM dd"
    }
    
    var currentDate: String {
        return dateFormatter.string(from: Date()).uppercased()
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
}
