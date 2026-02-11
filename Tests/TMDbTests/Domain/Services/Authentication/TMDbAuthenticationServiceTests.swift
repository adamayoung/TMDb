//
//  TMDbAuthenticationServiceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .authentication))
struct TMDbAuthenticationServiceTests {

    var service: TMDbAuthenticationService!
    var apiClient: MockAPIClient!
    var authenticateURLBuilder: AuthenticateURLMockBuilder!

    init() {
        self.apiClient = MockAPIClient()
        self.authenticateURLBuilder = AuthenticateURLMockBuilder()
        self.service = TMDbAuthenticationService(
            apiClient: apiClient, authenticateURLBuilder: authenticateURLBuilder
        )
    }

    @Test("guestSession returns guest session")
    func guestSessionReturnsGuestSession() async throws {
        let expectedResult = GuestSession.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = CreateGuestSessionRequest()

        let result = try await service.guestSession()

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? CreateGuestSessionRequest == expectedRequest)
    }

    @Test("guestSession when errors throws error")
    func guestSessionWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.guestSession()
        }
    }

    @Test("requestToken returns token")
    func requestTokenReturnsToken() async throws {
        let expectedResult = Token.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = CreateRequestTokenRequest()

        let result = try await service.requestToken()

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? CreateRequestTokenRequest == expectedRequest)
    }

    @Test("requestToken when errors throws error")
    func requestTokenWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.requestToken()
        }
    }

    @Test("authenticateURL with default parameter values returns URL")
    func authenticateURLWithDefaultParameterValuesReturnsURL() throws {
        let expiresAt = Date(timeIntervalSince1970: 1_705_956_596)
        let token = Token(success: true, requestToken: "abc123", expiresAt: expiresAt)
        let expectedURL = try #require(URL(string: "https://some.domain.com/authenticate/abc123"))
        authenticateURLBuilder.authenticateURLResult = expectedURL

        let url = (service as AuthenticationService).authenticateURL(for: token)

        #expect(url == expectedURL)
        #expect(authenticateURLBuilder.lastRequestToken == token.requestToken)
        #expect(authenticateURLBuilder.lastRedirectURL == nil)
    }

    @Test("authenticateURL with redirectURL returns URL")
    func authenticateURLWithRedirectURLReturnsURL() throws {
        let expiresAt = Date(timeIntervalSince1970: 1_705_956_596)
        let token = Token(success: true, requestToken: "abc123", expiresAt: expiresAt)
        let redirectURL = try #require(URL(string: "https://some.domain.com/auth/callback"))
        let expectedURL = try #require(URL(string: "https://some.domain.com/authenticate/abc123"))
        authenticateURLBuilder.authenticateURLResult = expectedURL

        let url = service.authenticateURL(for: token, redirectURL: redirectURL)

        #expect(url == expectedURL)
        #expect(authenticateURLBuilder.lastRequestToken == token.requestToken)
        #expect(authenticateURLBuilder.lastRedirectURL == redirectURL)
    }

    @Test("createSession with token returns session")
    func createSessionWithTokenReturnsSession() async throws {
        let token = Token(
            success: true, requestToken: "abc123",
            expiresAt: Date(timeIntervalSince1970: 1_705_956_596)
        )
        let expectedResult = Session(success: true, sessionID: "987yxz")
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = CreateSessionRequest(requestToken: token.requestToken)

        let result = try await service.createSession(withToken: token)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? CreateSessionRequest == expectedRequest)
    }

    @Test("createSession with token when errors throws error")
    func createSessionWithTokenWhenErrorsThrowsError() async throws {
        let token = Token(
            success: true, requestToken: "abc123",
            expiresAt: Date(timeIntervalSince1970: 1_705_956_596)
        )
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.createSession(withToken: token)
        }
    }

    @Test("createSession with token when errors throws error")
    func createSessionWithTokenWhenRequestTokenErrorsThrowsError() async throws {
        let token = Token(
            success: true, requestToken: "abc123",
            expiresAt: Date(timeIntervalSince1970: 1_705_956_596)
        )
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.createSession(withToken: token)
        }
    }

    @Test("createSession with v4 access token returns session")
    func createSessionWithV4AccessTokenReturnsSession() async throws {
        let accessToken = "v4-access-token-123"
        let expectedResult = Session(success: true, sessionID: "987yxz")
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = CreateSessionFromV4AccessTokenRequest(
            accessToken: accessToken
        )

        let result = try await service.createSession(
            withV4AccessToken: accessToken
        )

        #expect(result == expectedResult)
        #expect(
            apiClient.lastRequest
                as? CreateSessionFromV4AccessTokenRequest
                == expectedRequest
        )
    }

    @Test("createSession with v4 access token when errors throws error")
    func createSessionWithV4AccessTokenWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.createSession(
                withV4AccessToken: "v4-token"
            )
        }
    }

    @Test("createSession with credential returns session")
    func createSessionWithCredentialReturnsSession() async throws {
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

        #expect(result == expectedResult)

        let createTokenRequest = apiClient.request(atRequestIndex: 0) as? CreateRequestTokenRequest
        #expect(createTokenRequest == expectedCreateRequestTokenRequest)

        let validateTokenWithLoginRequest =
            apiClient.request(atRequestIndex: 1) as? ValidateTokenWithLoginRequest
        #expect(validateTokenWithLoginRequest == expectedValidateTokenWithLoginRequest)

        let createSessionRequest = apiClient.request(atRequestIndex: 2) as? CreateSessionRequest
        #expect(createSessionRequest == expectedCreateSessionRequest)
    }

    @Test("createSession with credential when errors throws error")
    func createSessionWithCredentialWhenValidateTokenErrorsThrowsError() async throws {
        let credential = Credential(username: "test", password: "pass123")
        let token = Token.mock()

        apiClient.addResponse(.success(token))
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.createSession(withCredential: credential)
        }
    }

    @Test("delteSession when successful returns true")
    func deleteSessionWhenSuccessfulReturnsTrue() async throws {
        let response = SuccessResult(success: true)
        let session = Session.mock()
        apiClient.addResponse(.success(response))
        let expectedRequest = DeleteSessionRequest(sessionID: session.sessionID)

        let result = try await service.deleteSession(session)

        #expect(result)
        #expect(apiClient.lastRequest as? DeleteSessionRequest == expectedRequest)
    }

    @Test("deleteSession when not successful returns false")
    func deleteSessionWhenNotSuccessfulReturnsFalse() async throws {
        let response = SuccessResult(success: false)
        apiClient.addResponse(.success(response))
        let session = Session.mock()

        let result = try await service.deleteSession(session)

        #expect(!result)
    }

    @Test("deleteSession when errors throws error")
    func deleteSessionWhenErrorsThrowsError() async throws {
        let session = Session.mock()
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.deleteSession(session)
        }
    }

    @Test("validateKey when successful returns true")
    func validateKeyWhenSuccessfulReturnsTrue() async throws {
        let response = SuccessResult(success: true)
        apiClient.addResponse(.success(response))
        let expectedRequest = ValidateKeyRequest()

        let result = try await service.validateKey()

        #expect(result)
        #expect(apiClient.lastRequest as? ValidateKeyRequest == expectedRequest)
    }

    @Test("validateKey when not successful returns false")
    func validateKeyWhenNotSuccessfulReturnsFalse() async throws {
        let response = SuccessResult(success: false)
        apiClient.addResponse(.success(response))
        let expectedRequest = ValidateKeyRequest()

        let result = try await service.validateKey()

        #expect(!result)
        #expect(apiClient.lastRequest as? ValidateKeyRequest == expectedRequest)
    }

    @Test("validateKey when errors throws error")
    func validateKeyWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.validateKey()
        }
    }

}
