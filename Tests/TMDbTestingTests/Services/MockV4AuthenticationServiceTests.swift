//
//  MockV4AuthenticationServiceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
import TMDb
import TMDbTesting

@Suite(.tags(.testingSupport, .mocks, .authentication))
struct MockV4AuthenticationServiceTests {

    var service: MockV4AuthenticationService

    init() {
        self.service = MockV4AuthenticationService()
    }

    @Test("requestToken returns the sample by default")
    func requestTokenReturnsSampleByDefault() async throws {
        let result = try await service.requestToken()

        #expect(result == .sample)
    }

    @Test("requestToken records the redirect URL it was called with")
    func requestTokenRecordsCall() async throws {
        let redirectURL = try #require(URL(string: "https://my.domain.com/callback"))

        _ = try await service.requestToken(redirectURL: redirectURL)

        #expect(service.requestTokenCalls.count == 1)
        #expect(service.requestTokenCalls.first?.redirectURL == redirectURL)
    }

    @Test("requestToken throws the injected failure")
    func requestTokenThrowsInjectedFailure() async throws {
        service.requestTokenResult = .failure(.unknown)

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.requestToken()
        }
    }

    @Test("createAccessToken returns the injected success")
    func createAccessTokenReturnsInjectedSuccess() async throws {
        let expectedResult = V4AccessToken(
            success: true,
            accessToken: "injected",
            accountID: "account1"
        )
        service.createAccessTokenResult = .success(expectedResult)

        let result = try await service.createAccessToken(withRequestToken: .sample)

        #expect(result == expectedResult)
        #expect(service.createAccessTokenCalls.count == 1)
    }

    @Test("authenticateURL records the token and returns the stubbed URL")
    func authenticateURLRecordsCall() throws {
        let expectedURL = try #require(URL(string: "https://stub.example.com/approve"))
        service.authenticateURLResult = expectedURL

        let url = service.authenticateURL(for: .sample)

        #expect(url == expectedURL)
        #expect(service.authenticateURLCalls.first?.requestToken == .sample)
    }

    @Test("authenticateURL by default returns the TMDb approval URL")
    func authenticateURLReturnsDefaultURL() throws {
        let expectedURL = try #require(URL(string: "https://www.themoviedb.org/auth/access"))

        let url = service.authenticateURL(for: .sample)

        #expect(url == expectedURL)
    }

    @Test("deleteAccessToken records the token it revoked")
    func deleteAccessTokenRecordsCall() async throws {
        let result = try await service.deleteAccessToken("token123")

        #expect(result == true)
        #expect(service.deleteAccessTokenCalls.first?.accessToken == "token123")
    }

    @Test("deleteAccessToken returns the injected false result")
    func deleteAccessTokenReturnsInjectedFalse() async throws {
        service.deleteAccessTokenResult = .success(false)

        let result = try await service.deleteAccessToken("token123")

        #expect(result == false)
    }

}
