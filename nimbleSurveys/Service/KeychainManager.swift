//
//  KeychainManager.swift
//  nimbleSurveys
//
//  Created by Felicitas Figueroa Fagalde on 06/11/2023.
//

import Foundation
import KeychainSwift

class KeychainManager {
    static let shared = KeychainManager()
    private let keychain = KeychainSwift()

    func saveToken(accessToken: String, refreshToken: String) {
        keychain.set(accessToken, forKey: "accessToken")
        keychain.set(refreshToken, forKey: "refreshToken")
    }
    
    func saveUser(email: String, username: String) {
        keychain.set(email, forKey: "userEmail")
        keychain.set(username, forKey: "username")
    }
    
}
