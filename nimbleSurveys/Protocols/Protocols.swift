//
//  Protocols.swift
//  nimbleSurveys
//
//  Created by Felicitas Figueroa Fagalde on 06/11/2023.
//

import Foundation
import Alamofire

protocol HTTPClientProtocol {
    func request(_ url: URLConvertible,
                 method: HTTPMethod,
                 parameters: Parameters?,
                 encoding: ParameterEncoding,
                 headers: HTTPHeaders?,
                 completion: @escaping (AFDataResponse<Data>) -> Void)
}


protocol TokenStorageProtocol {
    func set(_ value: String, forKey key: String) -> Bool
    func get(_ key: String) -> String?
    func delete(_ key: String) -> Bool
    func saveToken(accessToken: String, refreshToken: String)
    func saveRefreshToken(_ refreshToken: String)
}
