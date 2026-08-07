//
//  V4AuthenticationIntegrationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
import TMDb

///
/// Live coverage of the v4 authentication flow, as far as it can be automated.
///
/// Only the first step is reachable without a human: exchanging a request token
/// for an access token requires the user to approve it in a browser, so
/// `createAccessToken(withRequestToken:)` and `deleteAccessToken(_:)` cannot be
/// integration-tested. Their request construction is covered by the unit suite.
///
/// These endpoints authenticate with a bearer credential, so the suite builds
/// its client from `TMDB_API_READ_ONLY_TOKEN` rather than the v3 API key — a
/// v3 key is rejected here — and skips when that variable is absent, including
/// on CI.
///
@Suite(
    .integrationGate,
    .serialized,
    .tags(.authentication),
    .enabled(if: CredentialHelper.shared.hasAPIReadOnlyToken)
)
struct V4AuthenticationIntegrationTests {

    var client: TMDbClient!

    init() {
        self.client = TMDbClient(
            bearerToken: CredentialHelper.shared.tmdbAPIReadOnlyToken,
            configuration: TMDbConfiguration(retry: .default)
        )
    }

    @Test("requestToken returns an approvable request token")
    func requestTokenReturnsRequestToken() async throws {
        let token = try await client.v4Authentication.requestToken()

        #expect(token.success)
        #expect(!token.requestToken.isEmpty)
    }

    @Test("authenticateURL points at the TMDb approval page for the token")
    func authenticateURLReturnsApprovalURL() async throws {
        let token = try await client.v4Authentication.requestToken()

        let url = client.v4Authentication.authenticateURL(for: token)

        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        #expect(components.host == "www.themoviedb.org")
        #expect(components.path == "/auth/access")
        let requestTokenItem = components.queryItems?.first { $0.name == "request_token" }
        #expect(requestTokenItem?.value == token.requestToken)
    }

}
