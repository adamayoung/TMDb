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

        apiClient.addResponse(.success(expectedResult))

        let result = try await service.guestSession()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, AuthenticationEndpoint.createGuestSession.path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testGuestSessionWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

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

        apiClient.addResponse(.success(expectedResult))

        let result = try await service.requestToken()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, AuthenticationEndpoint.createRequestToken.path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testRequestTokenWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

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

    func testCreateSessionWithTokenReturnsSession() async throws {
        let token = Token(success: true, requestToken: "abc123", expiresAt: Date(timeIntervalSince1970: 1_705_956_596))
        let expectedRequestBody = CreateSessionRequestBody(requestToken: token.requestToken)
        let expectedResult = Session(success: true, sessionID: "987yxz")
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.createSession(withToken: token)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, AuthenticationEndpoint.createSession.path)
        XCTAssertEqual(apiClient.lastRequestMethod, .post)
        XCTAssertEqual(apiClient.lastRequestBody as? CreateSessionRequestBody, expectedRequestBody)
    }

    func testCreateSessionWithTokenWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            _ = try await service.requestToken()
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

    func testCreateSessionWithUsernameReturnsSession() async throws {
        let credential = Credential(username: "test", password: "pass123")

        let token = Token.mock()
        apiClient.addResponse(.success(token))

        let expectedCreateSessionWithLogin = CreateSessionWithLoginRequestBody(
            username: credential.username,
            password: credential.password,
            requestToken: token.requestToken
        )
        apiClient.addResponse(.success(token))

        let expectedCreateSession = CreateSessionRequestBody(requestToken: token.requestToken)
        let expectedResult = Session(success: true, sessionID: "987yxz")
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.createSession(withCredential: credential)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.requestURL(atRequestIndex: 0), AuthenticationEndpoint.createRequestToken.path)
        XCTAssertEqual(apiClient.requestMethod(atRequestIndex: 0), .get)
        XCTAssertEqual(
            apiClient.requestURL(atRequestIndex: 1),
            AuthenticationEndpoint.validateRequestTokenWithLogin.path
        )
        XCTAssertEqual(apiClient.requestMethod(atRequestIndex: 1), .post)
        XCTAssertEqual(
            apiClient.requestBody(atRequestIndex: 1) as? CreateSessionWithLoginRequestBody,
            expectedCreateSessionWithLogin
        )
        XCTAssertEqual(apiClient.requestURL(atRequestIndex: 2), AuthenticationEndpoint.createSession.path)
        XCTAssertEqual(apiClient.requestMethod(atRequestIndex: 2), .post)
        XCTAssertEqual(apiClient.requestBody(atRequestIndex: 2) as? CreateSessionRequestBody, expectedCreateSession)
    }

    func testDeleteSessionWhenSuccessfulReturnsTrue() async throws {
        let response = SuccessResult(success: true)
        apiClient.addResponse(.success(response))
        let session = Session.mock()
        let expectedDeleteSession = DeleteSessionRequestBody(sessionID: session.sessionID)

        let result = try await service.deleteSession(session)

        XCTAssertTrue(result)
        XCTAssertEqual(apiClient.lastRequestURL, AuthenticationEndpoint.deleteSession.path)
        XCTAssertEqual(apiClient.lastRequestMethod, .delete)
        XCTAssertEqual(apiClient.lastRequestBody as? DeleteSessionRequestBody, expectedDeleteSession)
    }

    func testDeleteSessionWhenNotSuccessfulReturnsFalse() async throws {
        let response = SuccessResult(success: false)
        apiClient.addResponse(.success(response))
        let session = Session.mock()

        let result = try await service.deleteSession(session)

        XCTAssertFalse(result)
    }

    func testDeleteSessionWhenErrorsThrowsError() async throws {
        let session = Session.mock()
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            _ = try await service.deleteSession(session)
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

}
