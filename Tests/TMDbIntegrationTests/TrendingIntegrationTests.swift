//
//  TrendingIntegrationTests.swift
//  TMDb
//
//  Copyright © 2025 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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
