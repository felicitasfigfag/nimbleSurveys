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
    private let httpClient: HTTPClientProtocol
    private let tokenStorage: TokenStorageProtocol
    private let clientID: String
    private let clientSecret: String
    private let tokenURL: String

    init(httpClient: HTTPClientProtocol = NetworkClient(),
         tokenStorage: TokenStorageProtocol = TokenStorageManager(),
         environment: [String: String] = ProcessInfo.processInfo.environment) {
        
        guard let clientID = environment["CLIENT_ID"],
              let clientSecret = environment["CLIENT_SECRET"],
              let tokenURL = environment["TOKEN_URL"]
        else {
            fatalError("Falta una variable de entorno necesaria para la autenticación.")
        }
        
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.tokenURL = tokenURL
        self.httpClient = httpClient
        self.tokenStorage = tokenStorage
    }
    

    func loginWithCredentials(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        login(email: email, password: password, completion: completion)
    }

    func login(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let loginParameters: [String: Any] = [
            AuthParamKey.grantType: "password",
            AuthParamKey.email: email,
            AuthParamKey.password: password,
            AuthParamKey.clientID: clientID,
            AuthParamKey.clientSecret: clientSecret
        ]
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        
        AF.request(tokenURL, method: .post, parameters: loginParameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let tokenResponse = try self.decodeAccessTokenResponse(from: data)
                        TokenStorageManager.shared.saveToken(accessToken: tokenResponse.data.attributes.accessToken,
                                                         refreshToken: tokenResponse.data.attributes.refreshToken)
                        completion(true, nil)
                    } catch {
                        self.handleError(error: .jsonDecodingError(error), completion: completion)
                    }
                case .failure(let error):
                    self.handleError(error: .networkError(error), completion: completion)
                }
            }
    }

    
    func refreshToken(refreshToken: String, completion: @escaping (Bool, Error?) -> Void) {
        let refreshParameters = [
             AuthParamKey.grantType: "refreshToken",
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
                    self.handleError(error: .networkError(error), completion: completion)
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

extension AuthService {
    func handleError(error: AuthServiceError, completion: @escaping (Bool, Error?) -> Void) {
        // In the future we would use a function like this to fire Alerts to the user in the case of an error
        print(error.localizedDescription) // Log the error
        completion(false, error)
    }
}
