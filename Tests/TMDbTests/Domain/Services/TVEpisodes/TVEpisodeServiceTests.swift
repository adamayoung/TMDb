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

@testable import TMDb
import XCTest

final class TVEpisodeServiceTests: XCTestCase {

    var service: TVEpisodeService!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        service = TVEpisodeService(apiClient: apiClient)
    }

    override func tearDown() {
        apiClient = nil
        service = nil
        super.tearDown()
    }

    func testDetailsReturnsTVEpisode() async throws {
        let tvSeriesID = Int.randomID
        let expectedResult = TVEpisode.mock()
        let seasonNumber = expectedResult.seasonNumber
        let episodeNumber = expectedResult.episodeNumber
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVEpisodeRequest(
            episodeNumber: episodeNumber,
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            language: nil
        )

        let result = try await service.details(
            forEpisode: episodeNumber,
            inSeason: seasonNumber,
            inTVSeries: tvSeriesID
        )

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TVEpisodeRequest, expectedRequest)
    }

    func testDetailsWithLanguageReturnsTVEpisode() async throws {
        let tvSeriesID = Int.randomID
        let expectedResult = TVEpisode.mock()
        let seasonNumber = expectedResult.seasonNumber
        let episodeNumber = expectedResult.episodeNumber
        let language = "en"
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVEpisodeRequest(
            episodeNumber: episodeNumber,
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            language: language
        )

        let result = try await service.details(
            forEpisode: episodeNumber,
            inSeason: seasonNumber,
            inTVSeries: tvSeriesID,
            language: language
        )

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TVEpisodeRequest, expectedRequest)
    }

    func testImagesReturnsImages() async throws {
        let episodeNumber = Int.randomID
        let seasonNumber = Int.randomID
        let tvSeriesID = Int.randomID
        let expectedResult = TVEpisodeImageCollection.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVEpisodeImagesRequest(
            episodeNumber: episodeNumber,
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            languages: nil
        )

        let result = try await service.images(
            forEpisode: episodeNumber,
            inSeason: seasonNumber,
            inTVSeries: tvSeriesID
        )

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TVEpisodeImagesRequest, expectedRequest)
    }

    func testImagesWithFilterReturnsImages() async throws {
        let episodeNumber = Int.randomID
        let seasonNumber = Int.randomID
        let tvSeriesID = Int.randomID
        let languages = ["en-GB", "fr"]
        let expectedResult = TVEpisodeImageCollection.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVEpisodeImagesRequest(
            episodeNumber: episodeNumber,
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            languages: languages
        )

        let filter = TVEpisodeImageFilter(languages: languages)
        let result = try await service.images(
            forEpisode: episodeNumber,
            inSeason: seasonNumber,
            inTVSeries: tvSeriesID,
            filter: filter
        )

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TVEpisodeImagesRequest, expectedRequest)
    }

    func testVideosReturnsVideos() async throws {
        let episodeNumber = Int.randomID
        let seasonNumber = Int.randomID
        let tvSeriesID = Int.randomID
        let expectedResult = VideoCollection.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVEpisodeVideosRequest(
            episodeNumber: episodeNumber,
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            languages: nil
        )

        let result = try await service.videos(
            forEpisode: episodeNumber,
            inSeason: seasonNumber,
            inTVSeries: tvSeriesID
        )

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TVEpisodeVideosRequest, expectedRequest)
    }

    func testVideosWithFilterReturnsVideos() async throws {
        let episodeNumber = Int.randomID
        let seasonNumber = Int.randomID
        let tvSeriesID = Int.randomID
        let languages = ["en", "fr"]
        let expectedResult = VideoCollection.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVEpisodeVideosRequest(
            episodeNumber: episodeNumber,
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            languages: languages
        )

        let filter = TVEpisodeVideoFilter(languages: languages)
        let result = try await service.videos(
            forEpisode: episodeNumber,
            inSeason: seasonNumber,
            inTVSeries: tvSeriesID,
            filter: filter
        )

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TVEpisodeVideosRequest, expectedRequest)
    }

}
