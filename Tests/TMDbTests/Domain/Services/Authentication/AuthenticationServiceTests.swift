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
        let expectedRequest = CreateGuestSessionRequest()

        let result = try await service.guestSession()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? CreateGuestSessionRequest, expectedRequest)
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
        let expectedRequest = CreateRequestTokenRequest()

        let result = try await service.requestToken()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? CreateRequestTokenRequest, expectedRequest)
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
        let expectedResult = Session(success: true, sessionID: "987yxz")
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = CreateSessionRequest(requestToken: token.requestToken)

        let result = try await service.createSession(withToken: token)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? CreateSessionRequest, expectedRequest)
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

    func testCreateSessionWithCredentialReturnsSession() async throws {
        let credential = Credential(username: "test", password: "pass123")
        let token = Token.mock()
        let expectedResult = Session(success: true, sessionID: "987yxz")

        apiClient.addResponse(.success(token))
        apiClient.addResponse(.success(token))
        apiClient.addResponse(.success(expectedResult))

        let expectedCreateRequestTokenRequest = CreateRequestTokenRequest()
        let expectedValidateTokenWithLoginRequest = ValidateTokenWithLoginRequest(
            username: credential.username,
            password: credential.password,
            requestToken: token.requestToken
        )
        let expectedCreateSessionRequest = CreateSessionRequest(requestToken: token.requestToken)

        let result = try await service.createSession(withCredential: credential)

        XCTAssertEqual(result, expectedResult)

        let createTokenRequest = apiClient.request(atRequestIndex: 0) as? CreateRequestTokenRequest
        XCTAssertEqual(createTokenRequest, expectedCreateRequestTokenRequest)

        let validateTokenWithLoginRequest = apiClient.request(atRequestIndex: 1) as? ValidateTokenWithLoginRequest
        XCTAssertEqual(validateTokenWithLoginRequest, expectedValidateTokenWithLoginRequest)

        let createSessionRequest = apiClient.request(atRequestIndex: 2) as? CreateSessionRequest
        XCTAssertEqual(createSessionRequest, expectedCreateSessionRequest)
    }

    func testDeleteSessionWhenSuccessfulReturnsTrue() async throws {
        let response = SuccessResult(success: true)
        let session = Session.mock()
        apiClient.addResponse(.success(response))
        let expectedRequest = DeleteSessionRequest(sessionID: session.sessionID)

        let result = try await service.deleteSession(session)

        XCTAssertTrue(result)
        XCTAssertEqual(apiClient.lastRequest as? DeleteSessionRequest, expectedRequest)
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

    func testValidateKeyWhenSuccessfulReturnsTrue() async throws {
        let response = SuccessResult(success: true)
        apiClient.addResponse(.success(response))
        let expectedRequest = ValidateKeyRequest()

        let result = try await service.validateKey()

        XCTAssertTrue(result)
        XCTAssertEqual(apiClient.lastRequest as? ValidateKeyRequest, expectedRequest)
    }

    func testValidateKeyWhenNotSuccessfulReturnsFalse() async throws {
        let response = SuccessResult(success: false)
        apiClient.addResponse(.success(response))
        let expectedRequest = ValidateKeyRequest()

        let result = try await service.validateKey()

        XCTAssertFalse(result)
        XCTAssertEqual(apiClient.lastRequest as? ValidateKeyRequest, expectedRequest)
    }

    func testValidateKeyWhenErrorsReturnsFalse() async throws {
        apiClient.addResponse(.failure(.unknown))

        let result = try await service.validateKey()

        XCTAssertFalse(result)
    }

}
