//
//  DiscoverIntegrationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(
    .serialized,
    .tags(.discover),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct DiscoverIntegrationTests {

    var discoverService: (any DiscoverService)!

    init() {
        let apiKey = CredentialHelper.shared.tmdbAPIKey
        self.discoverService = TMDbClient(apiKey: apiKey).discover
    }

    @Test("movies")
    func movies() async throws {
        let movieList = try await discoverService.movies()

        #expect(!movieList.results.isEmpty)
    }

    @Test("movies with filter")
    func moviesWithFilter() async throws {
        let filter = DiscoverMovieFilter(
            genres: [28],
            voteAverageMin: 7.0
        )

        let movieList = try await discoverService.movies(filter: filter)

        #expect(!movieList.results.isEmpty)
    }

    @Test("TV series")
    func tvSeries() async throws {
        let tvSeriesList = try await discoverService.tvSeries()

        #expect(!tvSeriesList.results.isEmpty)
    }

    @Test("TV series with filter")
    func tvSeriesWithFilter() async throws {
        let filter = DiscoverTVSeriesFilter(firstAirDateYear: 2024)

        let tvSeriesList = try await discoverService.tvSeries(
            filter: filter
        )

        #expect(!tvSeriesList.results.isEmpty)
    }

}
