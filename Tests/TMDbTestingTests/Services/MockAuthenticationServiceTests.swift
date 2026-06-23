//
//  MockAuthenticationServiceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
import TMDb
import TMDbTesting

@Suite(.tags(.testingSupport, .mocks, .authentication))
struct MockAuthenticationServiceTests {

    var service: MockAuthenticationService

    init() {
        self.service = MockAuthenticationService()
    }

    // MARK: - authenticateURL (sync, non-throwing)

    @Test("authenticateURL by default returns the default authentication URL")
    func authenticateURLByDefaultReturnsDefaultURL() {
        let expected = URL(string: "https://www.themoviedb.org/authenticate")

        let result = service.authenticateURL(for: .sample, redirectURL: nil)

        #expect(result == expected)
    }

    @Test("authenticateURL returns the injected URL")
    func authenticateURLReturnsInjectedURL() throws {
        let injected = try #require(URL(string: "https://example.com/redirect"))
        service.authenticateURLResult = injected

        let result = service.authenticateURL(for: .sample, redirectURL: nil)

        #expect(result == injected)
    }

    @Test("authenticateURL records the call with its arguments")
    func authenticateURLRecordsCall() throws {
        let redirectURL = try #require(URL(string: "https://example.com/done"))

        _ = service.authenticateURL(for: .sample, redirectURL: redirectURL)

        #expect(service.authenticateURLCalls.count == 1)
        let call = try #require(service.authenticateURLCalls.first)
        #expect(call.token == .sample)
        #expect(call.redirectURL == redirectURL)
    }

    // MARK: - guestSession (Result-returning)

    @Test("guestSession by default returns the sample guest session and records the call")
    func guestSessionByDefaultReturnsSample() async throws {
        let result = try await service.guestSession()

        #expect(result == .sample)
        #expect(service.guestSessionCalls.count == 1)
    }

    @Test("guestSession throws the injected failure")
    func guestSessionThrowsInjectedFailure() async {
        service.guestSessionResult = .failure(.unknown)

        await #expect(throws: TMDbError.unknown) {
            try await service.guestSession()
        }
    }

    @Test("requestToken by default returns the sample token")
    func requestTokenByDefaultReturnsSample() async throws {
        let result = try await service.requestToken()

        #expect(result == .sample)
        #expect(service.requestTokenCalls.count == 1)
    }

    // MARK: - validateKey / deleteSession (Bool methods)

    @Test("validateKey by default returns true")
    func validateKeyByDefaultReturnsTrue() async throws {
        let result = try await service.validateKey()

        #expect(result == true)
        #expect(service.validateKeyCalls.count == 1)
    }

    @Test("validateKey returns the injected false result")
    func validateKeyReturnsInjectedFalse() async throws {
        service.validateKeyResult = .success(false)

        let result = try await service.validateKey()

        #expect(result == false)
    }

    @Test("deleteSession by default returns true and records the session argument")
    func deleteSessionByDefaultReturnsTrue() async throws {
        let result = try await service.deleteSession(.sample)

        #expect(result == true)
        let call = try #require(service.deleteSessionCalls.first)
        #expect(call.session == .sample)
    }

    @Test("deleteSession returns the injected false result")
    func deleteSessionReturnsInjectedFalse() async throws {
        service.deleteSessionResult = .success(false)

        let result = try await service.deleteSession(.sample)

        #expect(result == false)
    }

}
