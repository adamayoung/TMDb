//
//  SearchIntegrationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(
    .tags(.search),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct SearchIntegrationTests {

    var searchService: (any SearchService)!

    init() {
        let apiKey = CredentialHelper.shared.tmdbAPIKey
        self.searchService = TMDbClient(apiKey: apiKey).search
    }

    @Test("searchAll")
    func searchAll() async throws {
        let query = "barbie"

        let mediaList = try await searchService.searchAll(query: query)

        #expect(!mediaList.results.isEmpty)
    }

    @Test(
        "searchAll with 'Velvet Underground'",
        .bug(
            "https://github.com/adamayoung/TMDb/issues/227",
            "Searching for 'Velvet Underground' throws an unknown error"
        )
    )
    func searchAllWithVelvetUnderground() async throws {
        let query = "Velvet Underground"

        let mediaList = try await searchService.searchAll(query: query)

        #expect(!mediaList.results.isEmpty)
    }

    @Test("searchMovies")
    func searchMovies() async throws {
        let query = "avengers"

        let movieList = try await searchService.searchMovies(query: query)

        #expect(!movieList.results.isEmpty)
    }

    @Test("searchTVSeries")
    func searchTVSeries() async throws {
        let query = "game of thrones"

        let tvSeriesList = try await searchService.searchTVSeries(query: query)

        #expect(!tvSeriesList.results.isEmpty)
    }

    @Test("searchPeople")
    func searchPeople() async throws {
        let query = "tom hardy"

        let personList = try await searchService.searchPeople(query: query)

        #expect(!personList.results.isEmpty)
    }

}
