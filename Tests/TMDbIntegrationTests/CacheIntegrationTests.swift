//
//  CacheIntegrationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(
    .serialized,
    .tags(.cache),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct CacheIntegrationTests {

    var client: TMDbClient

    init() {
        let apiKey = CredentialHelper.shared.tmdbAPIKey
        let configuration = TMDbConfiguration(cache: .default)
        self.client = TMDbClient(apiKey: apiKey, configuration: configuration)
    }

    @Test("successful request with cache enabled returns correct data")
    func successfulRequestWithCacheEnabled() async throws {
        let movieID = 550

        let movie = try await client.movies.details(forMovie: movieID)

        #expect(movie.id == movieID)
        #expect(movie.title == "Fight Club")
    }

    @Test("repeated request with cache enabled returns same data")
    func repeatedRequestReturnsSameData() async throws {
        let movieID = 550

        let first = try await client.movies.details(forMovie: movieID)
        let second = try await client.movies.details(forMovie: movieID)

        #expect(first.id == second.id)
        #expect(first.title == second.title)
    }

    @Test("successful request with custom cache configuration returns correct data")
    func successfulRequestWithCustomCacheConfiguration() async throws {
        let apiKey = CredentialHelper.shared.tmdbAPIKey
        let cacheConfig = CacheConfiguration(
            defaultTTL: .seconds(300),
            maximumEntryCount: 50
        )
        let configuration = TMDbConfiguration(cache: cacheConfig)
        let customClient = TMDbClient(apiKey: apiKey, configuration: configuration)

        let movie = try await customClient.movies.details(forMovie: 550)

        #expect(movie.id == 550)
        #expect(movie.title == "Fight Club")
    }

    @Test("cache with retry returns correct data")
    func cacheWithRetryReturnsCorrectData() async throws {
        let apiKey = CredentialHelper.shared.tmdbAPIKey
        let configuration = TMDbConfiguration(
            retry: .default,
            cache: .default
        )
        let combinedClient = TMDbClient(apiKey: apiKey, configuration: configuration)

        let movie = try await combinedClient.movies.details(forMovie: 550)

        #expect(movie.id == 550)
        #expect(movie.title == "Fight Club")
    }

}
