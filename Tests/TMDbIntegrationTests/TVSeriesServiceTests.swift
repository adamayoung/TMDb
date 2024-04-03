//
//  TVSeriesServiceTests.swift
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

final class TVSeriesServiceTests: XCTestCase {

    var tvSeriesService: TVSeriesService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        let configuration = try tmdbConfiguration()
        tvSeriesService = TVSeriesService(configuration: configuration)
    }

    override func tearDown() {
        tvSeriesService = nil
        super.tearDown()
    }

    func testDetails() async throws {
        let tvSeriesID = 84958

        let tvSeries = try await tvSeriesService.details(forTVSeries: tvSeriesID)

        XCTAssertEqual(tvSeries.id, tvSeriesID)
        XCTAssertEqual(tvSeries.name, "Loki")
    }

    func testCredits() async throws {
        let tvSeriesID = 4604

        let credits = try await tvSeriesService.credits(forTVSeries: tvSeriesID)

        XCTAssertFalse(credits.cast.isEmpty)
        XCTAssertFalse(credits.crew.isEmpty)
    }

    func testReviews() async throws {
        let tvSeriesID = 76479

        let reviewList = try await tvSeriesService.reviews(forTVSeries: tvSeriesID)

        XCTAssertFalse(reviewList.results.isEmpty)
    }

    func testImages() async throws {
        let tvSeriesID = 76479

        let imageCollection = try await tvSeriesService.images(forTVSeries: tvSeriesID)

        XCTAssertEqual(imageCollection.id, tvSeriesID)
        XCTAssertFalse(imageCollection.backdrops.isEmpty)
        XCTAssertFalse(imageCollection.logos.isEmpty)
        XCTAssertFalse(imageCollection.posters.isEmpty)
    }

    func testVideos() async throws {
        let tvSeriesID = 76479

        let videoCollection = try await tvSeriesService.videos(forTVSeries: tvSeriesID)

        XCTAssertEqual(videoCollection.id, tvSeriesID)
        XCTAssertFalse(videoCollection.results.isEmpty)
    }

    func testRecommendations() async throws {
        let tvSeriesID = 76479

        let tvSeriesList = try await tvSeriesService.recommendations(forTVSeries: tvSeriesID)

        XCTAssertFalse(tvSeriesList.results.isEmpty)
    }

    func testSimilar() async throws {
        let tvSeriesID = 76479

        let tvSeriesList = try await tvSeriesService.similar(toTVSeries: tvSeriesID)

        XCTAssertFalse(tvSeriesList.results.isEmpty)
    }

    func testPopular() async throws {
        let tvSeriesList = try await tvSeriesService.popular()

        XCTAssertFalse(tvSeriesList.results.isEmpty)
    }

    func testExternalLinks() async throws {
        let tvSeriesID = 86423

        let linksCollection = try await tvSeriesService.externalLinks(forTVSeries: tvSeriesID)

        XCTAssertEqual(linksCollection.id, tvSeriesID)
        XCTAssertNotNil(linksCollection.imdb)
        XCTAssertNil(linksCollection.wikiData)
        XCTAssertNotNil(linksCollection.facebook)
        XCTAssertNotNil(linksCollection.instagram)
        XCTAssertNotNil(linksCollection.twitter)
    }

}
