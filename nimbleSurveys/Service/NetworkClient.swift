//
//  NetworkClient.swift
//  nimbleSurveys
//
//  Created by Felicitas Figueroa Fagalde on 06/11/2023.
//

import Foundation
import Alamofire

struct NetworkClient: HTTPClientProtocol {
    func request(_ url: URLConvertible,
                 method: HTTPMethod,
                 parameters: Parameters?,
                 encoding: ParameterEncoding,
                 headers: HTTPHeaders?,
                 completion: @escaping (AFDataResponse<Data>) -> Void) {
        
        AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
            .validate()
            .responseData(completionHandler: completion)
    }
}
