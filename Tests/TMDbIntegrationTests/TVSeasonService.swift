//
//  TVSeasonService.swift
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

final class TVSeasonServiceTests: XCTestCase {

    var tvSeasonService: TVSeasonService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        let configuration = try tmdbConfiguration()
        tvSeasonService = TVSeasonService(configuration: configuration)
    }

    override func tearDown() {
        tvSeasonService = nil
        super.tearDown()
    }

//    func testDetails() async throws {
//        let seasonNumber = 2
//        let tvSeriesID = 1399
//
//        let season = try await tvSeasonService.details(forSeason: seasonNumber, inTVSeries: tvSeriesID)
//
//        XCTAssertEqual(season.seasonNumber, seasonNumber)
//        XCTAssertFalse((season.episodes ?? []).isEmpty)
//    }
//
//    func testAggregateCredits() async throws {
//        let seasonNumber = 2
//        let tvSeriesID = 1399
//
//        let credits = try await tvSeasonService.aggregateCredits(forSeason: seasonNumber, inTVSeries: tvSeriesID)
//
//        XCTAssertEqual(credits.id, 3625)
//        XCTAssertFalse(credits.cast.isEmpty)
//        XCTAssertFalse(credits.crew.isEmpty)
//    }
//
//    func testImages() async throws {
//        let seasonNumber = 1
//        let tvSeriesID = 1399
//
//        let imagesCollection = try await tvSeasonService.images(forSeason: seasonNumber, inTVSeries: tvSeriesID)
//
//        XCTAssertFalse(imagesCollection.posters.isEmpty)
//    }

    func testVideos() async throws {
        let seasonNumber = 1
        let tvSeriesID = 1399

        let videoCollection = try await tvSeasonService.videos(forSeason: seasonNumber, inTVSeries: tvSeriesID)

        XCTAssertFalse(videoCollection.results.isEmpty)
    }

    func testVideos2() async throws {
        let seasonNumber = 1
        let tvSeriesID = 1399

        let videoCollection = try await tvSeasonService.videos(forSeason: seasonNumber, inTVSeries: tvSeriesID)

        XCTAssertFalse(videoCollection.results.isEmpty)
    }

}
