//
//  AuthServiceTests.swift
//  nimbleSurveysTests
//
//  Created by Felicitas Figueroa Fagalde on 06/11/2023.
//

import XCTest
@testable import nimbleSurveys
import Alamofire

// MARK: - AuthServiceTests

class AuthServiceTests: XCTestCase {
    var authService: AuthService!
    var mockHTTPClient: MockHTTPClient!
    var mockTokenStorage: MockTokenStorageManager!
    
    override func setUp() {
        super.setUp()
        mockHTTPClient = MockHTTPClient()
        mockTokenStorage = MockTokenStorageManager()
        authService = AuthService(httpClient: mockHTTPClient, tokenStorage: mockTokenStorage)
    }
    
    override func tearDown() {
        authService = nil
        mockHTTPClient = nil
        mockTokenStorage = nil
        super.tearDown()
    }

    func testLoginWithValidCredentials() {
        // Expectations
        let loginExpectation = expectation(description: "Login completion handler invoked")

        // Setup mock response
        let expectedToken = "expectedToken"
        let expectedRefreshToken = "expectedRefreshToken"
        mockHTTPClient.requestHandler = { _, _, _, _, _, completion in  // Asegúrate de tener la cantidad correcta de parámetros aquí
            let statusCode = 200
            let url = URL(string: "https://example.com")!
            let response = HTTPURLResponse(url: url,
                                           statusCode: statusCode,
                                           httpVersion: "HTTP/1.1",
                                           headerFields: nil)!
            
            let responseJSON = """
            {
                "data": {
                    "id": "9973",
                    "type": "token",
                    "attributes": {
                        "access_token": "\(expectedToken)",
                        "token_type": "Bearer",
                        "expires_in": 7200,
                        "refresh_token": "\(expectedRefreshToken)",
                        "created_at": 1699262061
                    }
                }
            }
            """.data(using: .utf8)!
            
            let result: Result<Data, AFError> = .success(responseJSON)
            
            // Crea un objeto AFDataResponse con los tipos correctos
            let dataResponse = AFDataResponse(request: nil, response: response, data: responseJSON, metrics: nil, serializationDuration: 0, result: result)
            
            // Llama a completion con el objeto dataResponse
            completion(dataResponse)
        }

        // Act
        authService.loginWithCredentials(email: "test@example.com", password: "password") { success, error in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            loginExpectation.fulfill()
        }

        // Assert
        waitForExpectations(timeout: 1) { error in
            XCTAssertNil(error, "Test timeout")
        }
    }
}

