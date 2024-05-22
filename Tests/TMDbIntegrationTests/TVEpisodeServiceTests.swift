//
//  TVEpisodeServiceTests.swift
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

import TMDb
import XCTest

final class TVEpisodeServiceTests: XCTestCase {

    var tvEpisodeService: (any TVEpisodeService)!

    override func setUpWithError() throws {
        try super.setUpWithError()
        let apiKey = try tmdbAPIKey()
        tvEpisodeService = TMDbClient(apiKey: apiKey).tvEpisodes
    }

    override func tearDown() {
        tvEpisodeService = nil
        super.tearDown()
    }

    func testDetails() async throws {
        let episodeNumber = 3
        let seasonNumber = 2
        let tvSeriesID = 1399

        let episode = try await tvEpisodeService.details(
            forEpisode: episodeNumber,
            inSeason: seasonNumber,
            inTVSeries: tvSeriesID
        )

        XCTAssertEqual(episode.id, 63068)
        XCTAssertEqual(episode.episodeNumber, episodeNumber)
        XCTAssertEqual(episode.seasonNumber, seasonNumber)
        XCTAssertEqual(episode.name, "What is Dead May Never Die")
    }

    func testImages() async throws {
        let episodeNumber = 3
        let seasonNumber = 2
        let tvSeriesID = 1399

        let imageCollection = try await tvEpisodeService.images(
            forEpisode: episodeNumber,
            inSeason: seasonNumber,
            inTVSeries: tvSeriesID
        )

        XCTAssertEqual(imageCollection.id, 63068)
        XCTAssertFalse(imageCollection.stills.isEmpty)
    }

    func testVideos() async throws {
        let episodeNumber = 3
        let seasonNumber = 1
        let tvSeriesID = 1399

        let videoCollection = try await tvEpisodeService.videos(
            forEpisode: episodeNumber,
            inSeason: seasonNumber,
            inTVSeries: tvSeriesID
        )

        XCTAssertEqual(videoCollection.id, 63058)
        XCTAssertFalse(videoCollection.results.isEmpty)
    }

}
