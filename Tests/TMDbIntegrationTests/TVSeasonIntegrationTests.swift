//
//  TVSeasonIntegrationTests.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
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
    .tags(.tvSeason),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct TVSeasonIntegrationTests {

    var tvSeasonService: (any TVSeasonService)!

    init() {
        let apiKey = CredentialHelper.shared.tmdbAPIKey
        self.tvSeasonService = TMDbClient(apiKey: apiKey).tvSeasons
    }

    @Test("details")
    func testDetails() async throws {
        let seasonNumber = 2
        let tvSeriesID = 1399

        let season = try await tvSeasonService.details(forSeason: seasonNumber, inTVSeries: tvSeriesID)

        #expect(season.seasonNumber == seasonNumber)
        #expect(!(season.episodes ?? []).isEmpty)
    }

    @Test("aggregateCredits")
    func aggregateCredits() async throws {
        let seasonNumber = 2
        let tvSeriesID = 1399

        let credits = try await tvSeasonService.aggregateCredits(forSeason: seasonNumber, inTVSeries: tvSeriesID)

        #expect(credits.id == 3625)
        #expect(!credits.cast.isEmpty)
        #expect(!credits.crew.isEmpty)
    }

    @Test("images")
    func images() async throws {
        let seasonNumber = 1
        let tvSeriesID = 1399

        let imagesCollection = try await tvSeasonService.images(forSeason: seasonNumber, inTVSeries: tvSeriesID)

        #expect(!imagesCollection.posters.isEmpty)
    }

    @Test("videos")
    func videos() async throws {
        let seasonNumber = 1
        let tvSeriesID = 1399

        let videoCollection = try await tvSeasonService.videos(forSeason: seasonNumber, inTVSeries: tvSeriesID)

        #expect(!videoCollection.results.isEmpty)
    }

}
