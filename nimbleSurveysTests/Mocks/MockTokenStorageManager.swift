//
//  MockTokenStorageManager.swift
//  nimbleSurveysTests
//
//  Created by Felicitas Figueroa Fagalde on 06/11/2023.
//

import Foundation
@testable import nimbleSurveys

class MockTokenStorageManager: TokenStorageProtocol {
    var accessToken: String?
    var refreshToken: String?
    var email: String?
    var username: String?
    
    func saveToken(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
    
    func saveUser(email: String, username: String) {
        self.email = email
        self.username = username
    }
    
    func saveRefreshToken(_ refreshToken: String) {
        self.refreshToken = refreshToken
    }
    
    func set(_ value: String, forKey key: String) -> Bool {
        switch key {
        case "accessToken":
            accessToken = value
        case "refreshToken":
            refreshToken = value
        case "userEmail":
            email = value
        case "username":
            username = value
        default:
            return false
        }
        return true
    }
    
    func get(_ key: String) -> String? {
        switch key {
        case "accessToken":
            return accessToken
        case "refreshToken":
            return refreshToken
        case "userEmail":
            return email
        case "username":
            return username
        default:
            return nil
        }
    }
    
    func delete(_ key: String) -> Bool {
        switch key {
        case "accessToken":
            accessToken = nil
        case "refreshToken":
            refreshToken = nil
        case "userEmail":
            email = nil
        case "username":
            username = nil
        default:
            return false
        }
        return true
    }
}

