//
//  KeychainManager.swift
//  nimbleSurveys
//
//  Created by Felicitas Figueroa Fagalde on 06/11/2023.
//

import Foundation
import KeychainSwift

class TokenStorageManager {
    static let shared = TokenStorageManager()
    private let keychain = KeychainSwift()

    func saveToken(accessToken: String, refreshToken: String) {
        keychain.set(accessToken, forKey: "accessToken")
        keychain.set(refreshToken, forKey: "refreshToken")
    }
    
    func saveUser(email: String, username: String) {
        keychain.set(email, forKey: "userEmail")
        keychain.set(username, forKey: "username")
    }
    
    func saveRefreshToken(_ refreshToken: String) {
        keychain.set(refreshToken, forKey: "refreshToken")
    }
    
}

extension TokenStorageManager: TokenStorageProtocol {
    
    
    func set(_ value: String, forKey key: String) -> Bool {
        return keychain.set(value, forKey: key)
    }
    
    func get(_ key: String) -> String? {
        return keychain.get(key)
    }
    
    func delete(_ key: String) -> Bool {
        return keychain.delete(key)
    }
}

