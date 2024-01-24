//
//  AuthenticationServiceTests.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

@testable import TMDb
import XCTest

final class AuthenticationServiceTests: XCTestCase {

    var service: AuthenticationService!
    var apiClient: MockAPIClient!
    var authenticateURLBuilder: AuthenticateURLMockBuilder!

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        authenticateURLBuilder = AuthenticateURLMockBuilder()
        service = AuthenticationService(apiClient: apiClient, authenticateURLBuilder: authenticateURLBuilder)
    }

    override func tearDown() {
        service = nil
        authenticateURLBuilder = nil
        apiClient = nil
        super.tearDown()
    }

    func testGuestSessionReturnsGuestSession() async throws {
        let expectedResult = GuestSession.mock()

        apiClient.result = .success(expectedResult)

        let result = try await service.guestSession()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, AuthenticationEndpoint.createGuestSession.path)
    }

    func testGuestSessionWhenErrorsThrowsError() async throws {
        apiClient.result = .failure(.unknown)

        var error: Error?
        do {
            _ = try await service.guestSession()
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

    func testRequestTokenReturnsToken() async throws {
        let expectedResult = Token.mock()

        apiClient.result = .success(expectedResult)

        let result = try await service.requestToken()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, AuthenticationEndpoint.createRequestToken.path)
    }

    func testRequestTokenWhenErrorsThrowsError() async throws {
        apiClient.result = .failure(.unknown)

        var error: Error?
        do {
            _ = try await service.requestToken()
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

    func testAuthenticateURLReturnsURL() throws {
        let expiresAt = Date(timeIntervalSince1970: 1_705_956_596)
        let token = Token(success: true, requestToken: "abc123", expiresAt: expiresAt)
        let expectedURL = try XCTUnwrap(URL(string: "https://some.domain.com/authenticate/abc123"))
        authenticateURLBuilder.authenticateURLResult = expectedURL

        let url = service.authenticateURL(for: token)

        XCTAssertEqual(url, expectedURL)
        XCTAssertEqual(authenticateURLBuilder.lastRequestToken, token.requestToken)
        XCTAssertNil(authenticateURLBuilder.lastRedirectURL)
    }

    func testAuthenticateURLWithRedirectURLReturnsURL() throws {
        let expiresAt = Date(timeIntervalSince1970: 1_705_956_596)
        let token = Token(success: true, requestToken: "abc123", expiresAt: expiresAt)
        let redirectURL = try XCTUnwrap(URL(string: "https://some.domain.com/auth/callback"))
        let expectedURL = try XCTUnwrap(URL(string: "https://some.domain.com/authenticate/abc123"))
        authenticateURLBuilder.authenticateURLResult = expectedURL

        let url = service.authenticateURL(for: token, redirectURL: redirectURL)

        XCTAssertEqual(url, expectedURL)
        XCTAssertEqual(authenticateURLBuilder.lastRequestToken, token.requestToken)
        XCTAssertEqual(authenticateURLBuilder.lastRedirectURL, redirectURL)
    }

}
