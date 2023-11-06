import Foundation
import Alamofire
@testable import nimbleSurveys

// Alamofire Mock
// MockHTTPClient.swift

class MockHTTPClient: HTTPClientProtocol {
    
    var requestHandler: ((_ url: URLConvertible,
                          _ method: HTTPMethod,
                          _ parameters: Parameters?,
                          _ encoding: ParameterEncoding,
                          _ headers: HTTPHeaders?,
                          _ completion: @escaping (AFDataResponse<Data>) -> Void) -> Void)?

    func request(_ url: URLConvertible,
                 method: HTTPMethod,
                 parameters: Parameters?,
                 encoding: ParameterEncoding,
                 headers: HTTPHeaders?,
                 completion: @escaping (AFDataResponse<Data>) -> Void) {
        requestHandler?(url, method, parameters, encoding, headers, completion)
    }
}
