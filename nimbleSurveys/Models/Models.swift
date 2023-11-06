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

struct AccessTokenAttributes: Codable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int
    let refreshToken: String
    let createdAt: Int

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case createdAt = "created_at"
    }
}

struct AccessTokenData: Codable {
    let id: String
    let type: String
    let attributes: AccessTokenAttributes
}

struct AccessTokenResponse: Codable {
    let data: AccessTokenData
}


struct User: Codable {
    let id: String
    let type: String
    let email: String
    let username: String
}
