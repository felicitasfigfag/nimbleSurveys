//
//  Models.swift
//  nimbleSurveys
//
//  Created by Felicitas Figueroa Fagalde on 03/11/2023.
//

import Foundation

struct SlideData {
    var title: String
    var description: String
    var imageName: String
}

let mockSlides: [SlideData] = [
    SlideData(title: "Working from home",
              description: "We would like to know how you feel about our work from home...",
              imageName: "slideBkg1"),
    SlideData(title: "Career training and development", 
              description: "We would like to know what are your goals and skills you wanted...", 
              imageName: "slideBkg2"),
    SlideData(title: "Inclusion and belonging",
              description: "We would like to know what are your goals and skills you wanted...", 
              imageName: "slideBkg3")
]
