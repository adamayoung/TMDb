//
//  BearerTokenAuthIntegrationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

///
/// Verifies that a client configured with a v4 access token authenticates live
/// v3 requests via the `Authorization: Bearer` header.
///
/// Gated on `TMDB_ACCESS_TOKEN` (a TMDb API Read Access Token). It is skipped
/// when that variable is absent — including on CI, which provides only the v3
/// `TMDB_API_KEY` — so it runs only where a v4 token is supplied. The header vs
/// query-item behaviour itself is fully covered by `TMDbAPIClientCredentialTests`.
///
@Suite(
    .integrationGate,
    .serialized,
    .tags(.authentication),
    .enabled(if: CredentialHelper.shared.hasAccessToken)
)
struct BearerTokenAuthIntegrationTests {

    @Test("a bearer-token client authenticates a v3 request")
    func bearerTokenAuthenticatesRequest() async throws {
        let client = TMDbClient(
            bearerToken: CredentialHelper.shared.tmdbAccessToken,
            configuration: TMDbConfiguration(retry: .default)
        )

        let movie = try await client.movies.details(forMovie: 550, language: nil)

        #expect(movie.title.localizedCaseInsensitiveContains("Fight Club"))
    }

}
