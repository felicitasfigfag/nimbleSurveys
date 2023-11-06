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
    var mockKeychainManager: MockKeychainManager!

    override func setUp() {
        super.setUp()
        mockHTTPClient = MockHTTPClient()
        mockKeychainManager = MockKeychainManager()
        authService = AuthService(httpClient: mockHTTPClient, tokenStorage: mockKeychainManager)
    }

    override func tearDown() {
        mockHTTPClient = nil
        mockKeychainManager = nil
        authService = nil
        super.tearDown()
    }

    func testLoginWithCredentialsSuccess() {
        // Preparar datos de respuesta exitosa
        let data = """
        {
            "data": {
                "id": "1",
                "type": "tokens",
                "attributes": {
                    "access_token": "testAccessToken",
                    "token_type": "bearer",
                    "expires_in": 7200,
                    "refresh_token": "testRefreshToken",
                    "created_at": 1582266000
                }
            }
        }
        """.data(using: .utf8)!
        mockHTTPClient.dataResponse = data

        let expectation = self.expectation(description: "Login success")

        authService.loginWithCredentials(email: "test@example.com", password: "password") { success, error in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            XCTAssertEqual(self.mockKeychainManager.get(AuthParamKey.accessToken), "testAccessToken")
            XCTAssertEqual(self.mockKeychainManager.get(AuthParamKey.refreshToken), "testRefreshToken")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testLoginWithCredentialsFailure() {
        // Preparar AFError para simular un fallo de red
        mockHTTPClient.errorResponse = AFError.explicitlyCancelled

        let expectation = self.expectation(description: "Login failure")

        authService.loginWithCredentials(email: "test@example.com", password: "password") { success, error in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            XCTAssertNil(self.mockKeychainManager.get(AuthParamKey.accessToken))
            XCTAssertNil(self.mockKeychainManager.get(AuthParamKey.refreshToken))
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    // MARK: - DecodeAccessTokenResponse Tests

    // Tests decoding access token response with valid data should return a decoded object.
    func testDecodeAccessTokenResponseWithValidData() {
        let jsonData = """
        {
            "data": {
                "id": "1",
                "type": "token",
                "attributes": {
                    "access_token": "some_access_token",
                    "refresh_token": "some_refresh_token"
                }
            }
        }
        """.data(using: .utf8)!
        
        do {
            let tokenResponse = try authService.decodeAccessTokenResponse(from: jsonData)
            XCTAssertEqual(tokenResponse.data.attributes.accessToken, "some_access_token")
            XCTAssertEqual(tokenResponse.data.attributes.refreshToken, "some_refresh_token")
        } catch {
            XCTFail("Decoding should not fail with valid JSON data")
        }
    }

    // Tests decoding access token response with invalid data should throw an error.
    func testDecodeAccessTokenResponseWithInvalidData() {
        let jsonData = "invalid data".data(using: .utf8)!
        
        XCTAssertThrowsError(try authService.decodeAccessTokenResponse(from: jsonData)) { error in
            XCTAssertTrue(error is DecodingError)
        }
    }
}
