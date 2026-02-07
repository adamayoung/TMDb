//
//  RetryIntegrationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(
    .serialized,
    .tags(.retry),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct RetryIntegrationTests {

    var movieService: any MovieService

    init() {
        let apiKey = CredentialHelper.shared.tmdbAPIKey
        let configuration = TMDbConfiguration(retry: .default)
        self.movieService = TMDbClient(apiKey: apiKey, configuration: configuration).movies
    }

    @Test("successful request with retry enabled returns correct data")
    func successfulRequestWithRetryEnabled() async throws {
        let movieID = 550

        let movie = try await movieService.details(forMovie: movieID)

        #expect(movie.id == movieID)
        #expect(movie.title == "Fight Club")
    }

    @Test("successful request with custom retry configuration returns correct data")
    func successfulRequestWithCustomRetryConfiguration() async throws {
        let apiKey = CredentialHelper.shared.tmdbAPIKey
        let retryConfig = RetryConfiguration(
            maxRetries: 5,
            initialDelay: .seconds(2),
            retryableErrors: .rateLimit
        )
        let configuration = TMDbConfiguration(retry: retryConfig)
        let client = TMDbClient(apiKey: apiKey, configuration: configuration)

        let movie = try await client.movies.details(forMovie: 550)

        #expect(movie.id == 550)
        #expect(movie.title == "Fight Club")
    }

}
