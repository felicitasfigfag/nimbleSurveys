import Foundation
import Alamofire
import KeychainSwift
@testable import nimbleSurveys

// Alamofire Mock
class MockHTTPClient: HTTPClientProtocol {
    var nextData: Data?
    var nextError: Error?

    func request(_ url: URLConvertible,
                 method: HTTPMethod,
                 parameters: Parameters? = nil,
                 encoding: ParameterEncoding = URLEncoding.default,
                 headers: HTTPHeaders? = nil,
                 completion: @escaping (AFDataResponse<Data>) -> Void) {
        let response = HTTPURLResponse(
            url: try! url.asURL(),
            statusCode: nextError == nil ? 200 : 400,
            httpVersion: "1.1",
            headerFields: nil
        )

        let result: Result<Data, AFError> = nextError == nil
            ? .success(nextData ?? Data())
            : .failure(AFError.explicitlyCancelled)

        // Mimic the async nature of real HTTP requests
        DispatchQueue.main.async {
            let dataResponse = AFDataResponse<Data>(
                request: nil,
                response: response,
                data: self.nextData,
                metrics: nil,
                serializationDuration: 0,
                result: result
            )
            completion(dataResponse)
        }
    }
}


// Keychain mock
class MockKeychainManager: KeychainSwift {
    var storedValues = [String: String]()

    override func set(_ value: String, forKey key: String, withAccess access: KeychainSwiftAccessOptions? = nil) -> Bool {
        storedValues[key] = value
        return true
    }
    
    override func get(_ key: String) -> String? {
        return storedValues[key]
    }
    
    override func delete(_ key: String) -> Bool {
        storedValues[key] = nil
        return true
    }
}
