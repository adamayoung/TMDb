//
//  TrendingIntegrationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(
    .tags(.trending),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct TrendingIntegrationTests {

    var trendingService: (any TrendingService)!

    init() {
        let apiKey = CredentialHelper.shared.tmdbAPIKey
        self.trendingService = TMDbClient(apiKey: apiKey).trending
    }

    @Test("movies trending by day")
    func moviesTrendingByDay() async throws {
        let movieList = try await trendingService.movies(inTimeWindow: .day)

        #expect(!movieList.results.isEmpty)
    }

    @Test("movies trending by week")
    func moviesTrendingByWeek() async throws {
        let movieList = try await trendingService.movies(inTimeWindow: .week)

        #expect(!movieList.results.isEmpty)
    }

    @Test("tvSeries trending by day")
    func tvSeriesTrendingByDay() async throws {
        let tvSeriesList = try await trendingService.tvSeries(inTimeWindow: .day)

        #expect(!tvSeriesList.results.isEmpty)
    }

    @Test("tvSeries trending by week")
    func tvSeriesTrendingByWeek() async throws {
        let tvSeriesList = try await trendingService.tvSeries(inTimeWindow: .week)

        #expect(!tvSeriesList.results.isEmpty)
    }

    @Test("people trending by day")
    func peopleTrendingByDay() async throws {
        let personList = try await trendingService.people(inTimeWindow: .day)

        #expect(!personList.results.isEmpty)
    }

    @Test("people trending by week")
    func peopleTrendingByWeek() async throws {
        let personList = try await trendingService.people(inTimeWindow: .week)

        #expect(!personList.results.isEmpty)
    }

}
