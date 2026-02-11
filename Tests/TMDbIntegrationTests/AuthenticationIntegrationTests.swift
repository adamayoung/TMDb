//
//  AuthenticationIntegrationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(
    .serialized,
    .tags(.authentication),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct AuthenticationIntegrationTests {

    var authenticationService: (any AuthenticationService)!

    init() {
        let apiKey = CredentialHelper.shared.tmdbAPIKey
        self.authenticationService = TMDbClient(apiKey: apiKey).authentication
    }

    @Test("guestSession")
    func guestSession() async throws {
        let session = try await authenticationService.guestSession()

        #expect(session.success)
        #expect(session.guestSessionID != "")
    }

    @Test("requestToken")
    func requestToken() async throws {
        let token = try await authenticationService.requestToken()

        #expect(token.success)
        #expect(token.requestToken != "")
    }

    @Test(
        "createSession with credential",
        .enabled(if: CredentialHelper.shared.hasCredential),
        .disabled("TMDb validate_with_login endpoint rejects session creation")
    )
    func createAndDeleteSessionWithCredential() async throws {
        let credential = CredentialHelper.shared.tmdbCredential

        let session = try await authenticationService.createSession(withCredential: credential)

        #expect(session.success)
        #expect(session.sessionID != "")

        do {
            let deleteResult = try await authenticationService.deleteSession(session)
            #expect(deleteResult)
        } catch let error {
            print(error)
        }
    }

    @Test("validateKey")
    func validateKeyWhenValid() async throws {
        let isValid = try await authenticationService.validateKey()

        #expect(isValid)
    }

    @Test("authenticateURL returns valid URL")
    func authenticateURLReturnsValidURL() async throws {
        let token = try await authenticationService.requestToken()

        let url = authenticationService.authenticateURL(for: token, redirectURL: nil)

        #expect(url.host == "www.themoviedb.org")
        #expect(url.path.contains("authenticate") == true)
    }

    @Test("authenticateURL with redirect URL returns valid URL")
    func authenticateURLWithRedirectReturnsValidURL() async throws {
        let token = try await authenticationService.requestToken()
        let redirectURL = try #require(URL(string: "myapp://callback"))

        let url = authenticationService.authenticateURL(for: token, redirectURL: redirectURL)

        #expect(url.absoluteString.contains("redirect_to") == true)
    }

}
