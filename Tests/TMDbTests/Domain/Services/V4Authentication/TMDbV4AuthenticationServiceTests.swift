//
//  TMDbV4AuthenticationServiceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .authentication))
struct TMDbV4AuthenticationServiceTests {

    var service: TMDbV4AuthenticationService!
    var apiClient: MockAPIClient!
    var authenticateURLBuilder: V4AuthenticateURLMockBuilder!

    init() {
        self.apiClient = MockAPIClient()
        self.authenticateURLBuilder = V4AuthenticateURLMockBuilder()
        self.service = TMDbV4AuthenticationService(
            apiClient: apiClient,
            authenticateURLBuilder: authenticateURLBuilder
        )
    }

    @Test("requestToken returns a request token")
    func requestTokenReturnsRequestToken() async throws {
        let expectedResult = V4RequestToken(success: true, requestToken: "abc123")
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.requestToken()

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? CreateV4RequestTokenRequest == CreateV4RequestTokenRequest())
    }

    @Test("requestToken with a redirect URL threads it into the request")
    func requestTokenWithRedirectURLBuildsExpectedRequest() async throws {
        let redirectURL = try #require(URL(string: "https://my.domain.com/auth/callback"))
        apiClient.addResponse(.success(V4RequestToken(success: true, requestToken: "abc123")))

        _ = try await service.requestToken(redirectURL: redirectURL)

        let expectedRequest = CreateV4RequestTokenRequest(redirectURL: redirectURL)
        #expect(apiClient.lastRequest as? CreateV4RequestTokenRequest == expectedRequest)
    }

    @Test("requestToken when errors throws TMDbError")
    func requestTokenWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.requestToken()
        }
    }

    @Test("authenticateURL delegates to the URL builder")
    func authenticateURLDelegatesToBuilder() throws {
        let expectedURL = try #require(URL(string: "https://some.domain.com/auth/access"))
        authenticateURLBuilder.authenticateURLResult = expectedURL
        let requestToken = V4RequestToken(success: true, requestToken: "abc123")

        let url = service.authenticateURL(for: requestToken)

        #expect(url == expectedURL)
        #expect(authenticateURLBuilder.lastRequestToken == "abc123")
    }

    @Test("createAccessToken returns an access token")
    func createAccessTokenReturnsAccessToken() async throws {
        let expectedResult = V4AccessToken(
            success: true,
            accessToken: "token123",
            accountID: "account123"
        )
        apiClient.addResponse(.success(expectedResult))
        let requestToken = V4RequestToken(success: true, requestToken: "abc123")

        let result = try await service.createAccessToken(withRequestToken: requestToken)

        #expect(result == expectedResult)
        let expectedRequest = CreateV4AccessTokenRequest(requestToken: "abc123")
        #expect(apiClient.lastRequest as? CreateV4AccessTokenRequest == expectedRequest)
    }

    @Test("createAccessToken with an empty request token throws bad request and performs no request")
    func createAccessTokenWithEmptyTokenThrowsBadRequest() async throws {
        let requestToken = V4RequestToken(success: true, requestToken: "   ")
        let expectedError = TMDbError.badRequest(
            TMDbErrorContext(statusMessage: "Request token must not be empty")
        )

        await #expect(throws: expectedError) {
            _ = try await service.createAccessToken(withRequestToken: requestToken)
        }

        #expect(apiClient.requests.isEmpty)
    }

    @Test("createAccessToken when errors throws TMDbError")
    func createAccessTokenWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))
        let requestToken = V4RequestToken(success: true, requestToken: "abc123")

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.createAccessToken(withRequestToken: requestToken)
        }
    }

    @Test("deleteAccessToken returns the success flag")
    func deleteAccessTokenReturnsSuccess() async throws {
        apiClient.addResponse(.success(SuccessResult(success: true)))

        let result = try await service.deleteAccessToken("token123")

        #expect(result == true)
        let expectedRequest = DeleteV4AccessTokenRequest(accessToken: "token123")
        #expect(apiClient.lastRequest as? DeleteV4AccessTokenRequest == expectedRequest)
    }

    @Test("deleteAccessToken with an empty token throws bad request and performs no request")
    func deleteAccessTokenWithEmptyTokenThrowsBadRequest() async throws {
        let expectedError = TMDbError.badRequest(
            TMDbErrorContext(statusMessage: "Access token must not be empty")
        )

        await #expect(throws: expectedError) {
            _ = try await service.deleteAccessToken("   ")
        }

        #expect(apiClient.requests.isEmpty)
    }

    @Test("deleteAccessToken when errors throws TMDbError")
    func deleteAccessTokenWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.deleteAccessToken("token123")
        }
    }

}

/// A `V4AuthenticateURLBuilding` double that records the token it was asked for.
///
/// `@unchecked Sendable` is justified by the lock: every stored property is read
/// and written only while `lock` is held, so concurrent access is safe even
/// though the compiler cannot prove it.
final class V4AuthenticateURLMockBuilder: V4AuthenticateURLBuilding, @unchecked Sendable {

    private let lock = NSLock()
    private var storage = Storage()

    private struct Storage {
        var authenticateURLResult = URL(fileURLWithPath: "/")
        var lastRequestToken: String?
    }

    var authenticateURLResult: URL {
        get { withLock { storage.authenticateURLResult } }
        set { withLock { storage.authenticateURLResult = newValue } }
    }

    var lastRequestToken: String? {
        withLock { storage.lastRequestToken }
    }

    private func withLock<R>(_ body: () -> R) -> R {
        lock.lock()
        defer { lock.unlock() }
        return body()
    }

    func authenticateURL(with requestToken: String) -> URL {
        withLock {
            storage.lastRequestToken = requestToken
            return storage.authenticateURLResult
        }
    }

}
