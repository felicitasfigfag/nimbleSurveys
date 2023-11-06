//
//  AuthService.swift
//  nimbleSurveys
//
//  Created by Felicitas Figueroa Fagalde on 04/11/2023.
//

import Foundation
import Alamofire
import KeychainSwift
import Japx

struct AuthService {
    private var clientID: String {
        return ProcessInfo.processInfo.environment["CLIENT_ID"] ?? "default_client_id"
    }
        
    private var clientSecret: String {
        return ProcessInfo.processInfo.environment["CLIENT_SECRET"] ?? "default_client_secret"
    }
    private let tokenURL = "https://survey-api.nimblehq.co/api/v1/oauth/token"
    private let regURL = "https://survey-api.nimblehq.co/api/v1/registrations"

    func loginWithCredentials(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        login(email: email, password: password, completion: completion)
    }

    func login(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let loginParameters: [String: Any] = [
            "grant_type": "password",
            "email": email,
            "password": password,
            "client_id": clientID,
            "client_secret": clientSecret
        ]
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        
        AF.request(tokenURL, method: .post, parameters: loginParameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseData { response in
                debugPrint(response)
                
                switch response.result {
                case .success(let data):
                    do {
                        print(String(data: data, encoding: .utf8)!)
                        let tokenResponse = try decodeAccessTokenResponse(from: data)
                        KeychainManager.shared.saveToken(accessToken: tokenResponse.data.attributes.accessToken,
                                                         refreshToken: tokenResponse.data.attributes.refreshToken)
                        // Save user data if needed
                        // KeychainManager.shared.saveUser(email: userEmail, username: username)

                        completion(true, nil)
                    } catch {
                        print("Error during JSON decoding: \(error.localizedDescription)")
                        completion(false, error)
                    }
                case .failure(let error):
                    print("Error: \(error)")
                    completion(false, error)
                }
            }
    }

    
    
    func refreshToken(refreshToken: String, completion: @escaping (Bool, Error?) -> Void) {
        let refreshParameters = [
            "grant_type": "refresh_token",
            "refresh_token": refreshToken,
            "client_id": clientID,
            "client_secret": clientSecret
        ]
        
        AF.request(regURL, method: .post, parameters: refreshParameters, encoder: URLEncodedFormParameterEncoder.default)
            .validate()
            .responseDecodable(of: AccessTokenResponse.self) { response in
                switch response.result {
                case .success(let accessTokenResponse):
                    let keychain = KeychainSwift()
                    keychain.set(accessTokenResponse.data.attributes.accessToken, forKey: "accessToken")
                    keychain.set(accessTokenResponse.data.attributes.refreshToken, forKey: "refreshToken")
                    completion(true, nil)
                case .failure(let error):
                    completion(false, error)
                }
            }
    }

}

extension AuthService {
    func decodeAccessTokenResponse(from data: Data) throws -> AccessTokenResponse {
        let decoder = JSONDecoder()
        let response = try decoder.decode(AccessTokenResponse.self, from: data)
        return response
    }
}

