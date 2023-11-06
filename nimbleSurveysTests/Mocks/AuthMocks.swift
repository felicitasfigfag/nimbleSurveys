import Foundation
import Alamofire
import KeychainSwift
@testable import nimbleSurveys

// Alamofire Mock
enum MockResponseType {
    case success(Data)
    case error(Data, Int) // Includes the error data and the status code
}

class MockHTTPClient: HTTPClientProtocol {
    var requestCalled = false
    var shouldReturnError = false
    var dataResponse: Data?
    var errorResponse: AFError?

    func request(_ url: URLConvertible, method: HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding, headers: HTTPHeaders?, completion: @escaping (AFDataResponse<Data>) -> Void) {
        requestCalled = true

        let dummyURL = URL(string: "https://dummyurl.com")!

        if shouldReturnError {
            let response = AFDataResponse<Data>(
                request: nil,
                response: nil,
                data: nil,
                metrics: nil,
                serializationDuration: 0,
                result: .failure(errorResponse ?? AFError.explicitlyCancelled)
            )
            completion(response)
        } else {
            let response = AFDataResponse<Data>(
                request: nil,
                response: HTTPURLResponse(url: dummyURL, statusCode: 200, httpVersion: nil, headerFields: nil),
                data: dataResponse,
                metrics: nil,
                serializationDuration: 0,
                result: .success(dataResponse ?? Data())
            )
            completion(response)
        }
    }
}




// Keychain mock
class MockKeychainManager: TokenStorageProtocol {
    var storedValues = [String: String]()

    func set(_ value: String, forKey key: String) -> Bool {
        storedValues[key] = value
        return true
    }
    
    func get(_ key: String) -> String? {
        return storedValues[key]
    }
    
    func delete(_ key: String) -> Bool {
        storedValues[key] = nil
        return true
    }
}

