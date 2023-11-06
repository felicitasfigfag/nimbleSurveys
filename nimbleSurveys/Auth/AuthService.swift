//
//  AuthService.swift
//  nimbleSurveys
//
//  Created by Felicitas Figueroa Fagalde on 04/11/2023.
//

import Foundation
import Alamofire
import KeychainSwift

struct AuthService {
    private let clientID: String
    private let clientSecret: String
    private let tokenURL: String
    private let httpClient: HTTPClientProtocol
    private let keychain: KeychainProtocol

    init(httpClient: HTTPClientProtocol = Alamofire.Session.default,
            keychain: KeychainProtocol = KeychainManager(),
            environment: [String: String] = ProcessInfo.processInfo.environment) {
        
        guard let clientID = environment["CLIENT_ID"],
                let clientSecret = environment["CLIENT_SECRET"],
                let tokenURL = environment["TOKEN_URL"] 
        else {
            fatalError("Environment variables CLIENT_ID, CLIENT_SECRET, and TOKEN_URL must be set.")
        }
            
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.tokenURL = tokenURL
        self.httpClient = httpClient
        self.keychain = keychain
    }
    
    func loginWithCredentials(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        login(email: email, password: password, completion: completion)
    }

    func login(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        
        let loginParameters: [String: Any] = [
            AuthParamKey.grantType: password,
            AuthParamKey.email: email,
            AuthParamKey.password: password,
            AuthParamKey.clientID: clientID,
            AuthParamKey.clientSecret: clientSecret
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
             AuthParamKey.grantType: refreshToken,
             AuthParamKey.refreshToken: refreshToken,
             AuthParamKey.clientID: clientID,
             AuthParamKey.clientSecret: clientSecret
         ]
        
        AF.request(tokenURL, method: .post, parameters: refreshParameters, encoder: URLEncodedFormParameterEncoder.default)
            .validate()
            .responseDecodable(of: AccessTokenResponse.self) { response in
                switch response.result {
                case .success(let accessTokenResponse):
                    let keychain = KeychainSwift()
                    keychain.set(accessTokenResponse.data.attributes.accessToken, forKey: AuthParamKey.accessToken)
                    keychain.set(accessTokenResponse.data.attributes.refreshToken, forKey: AuthParamKey.refreshToken)
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

extension Alamofire.Session: HTTPClientProtocol {
    func request(_ url: URLConvertible,
                 method: HTTPMethod,
                 parameters: Parameters? = nil,
                 encoding: ParameterEncoding = URLEncoding.default,
                 headers: HTTPHeaders? = nil,
                 completion: @escaping (AFDataResponse<Data>) -> Void) {
        self.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
            .validate()
            .responseData(completionHandler: completion)
    }
}
