//
//  DiscoverIntegrationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.serialized, 
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

    @Test("TV series")
    func tvSeries() async throws {
        let tvSeriesList = try await discoverService.tvSeries()

        #expect(!tvSeriesList.results.isEmpty)
    }

}
