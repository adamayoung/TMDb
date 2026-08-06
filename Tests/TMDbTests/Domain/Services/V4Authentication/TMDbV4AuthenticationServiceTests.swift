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

    @Test("createAccessToken with an empty request token throws without performing a request")
    func createAccessTokenWithEmptyTokenThrowsError() async throws {
        let requestToken = V4RequestToken(success: true, requestToken: "")

        await #expect(throws: (any Error).self) {
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

    @Test("deleteAccessToken with an empty token throws without performing a request")
    func deleteAccessTokenWithEmptyTokenThrowsError() async throws {
        await #expect(throws: (any Error).self) {
            _ = try await service.deleteAccessToken("")
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

final class V4AuthenticateURLMockBuilder: V4AuthenticateURLBuilding, @unchecked Sendable {

    var authenticateURLResult: URL = .init(fileURLWithPath: "/")
    private(set) var lastRequestToken: String?
    private(set) var lastRedirectURL: URL?

    func authenticateURL(with requestToken: String) -> URL {
        authenticateURL(with: requestToken, redirectURL: nil)
    }

    func authenticateURL(with requestToken: String, redirectURL: URL?) -> URL {
        lastRequestToken = requestToken
        lastRedirectURL = redirectURL

        return authenticateURLResult
    }

}
