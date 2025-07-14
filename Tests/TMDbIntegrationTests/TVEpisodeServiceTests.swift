//
//  TVEpisodeServiceTests.swift
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
    .tags(.tvEpisode),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct TVEpisodeServiceTests {

    var tvEpisodeService: (any TVEpisodeService)!

    init() {
        let apiKey = CredentialHelper.shared.tmdbAPIKey
        self.tvEpisodeService = TMDbClient(apiKey: apiKey).tvEpisodes
    }

    @Test("details")
    func details() async throws {
        let episodeNumber = 3
        let seasonNumber = 2
        let tvSeriesID = 1399

        let episode = try await tvEpisodeService.details(
            forEpisode: episodeNumber,
            inSeason: seasonNumber,
            inTVSeries: tvSeriesID
        )

        #expect(episode.id == 63068)
        #expect(episode.episodeNumber == episodeNumber)
        #expect(episode.seasonNumber == seasonNumber)
        #expect(episode.name == "What is Dead May Never Die")
    }

    @Test("images")
    func images() async throws {
        let episodeNumber = 3
        let seasonNumber = 2
        let tvSeriesID = 1399

        let imageCollection = try await tvEpisodeService.images(
            forEpisode: episodeNumber,
            inSeason: seasonNumber,
            inTVSeries: tvSeriesID
        )

        #expect(imageCollection.id == 63068)
        #expect(!imageCollection.stills.isEmpty)
    }

    @Test("videos")
    func videos() async throws {
        let episodeNumber = 3
        let seasonNumber = 1
        let tvSeriesID = 1399

        let videoCollection = try await tvEpisodeService.videos(
            forEpisode: episodeNumber,
            inSeason: seasonNumber,
            inTVSeries: tvSeriesID
        )

        #expect(videoCollection.id == 63058)
        #expect(!videoCollection.results.isEmpty)
    }

}
