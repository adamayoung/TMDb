//
//  TVEpisodesEndpointTests.swift
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

final class TVEpisodesEndpointTests: XCTestCase {

    func testTVEpisodeDetailsEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/tv/1/season/2/episode/3"))

        let url = TVEpisodesEndpoint.details(tvSeriesID: 1, seasonNumber: 2, episodeNumber: 3).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVEpisodeImagesEndpointReturnsURL() throws {
        let languageCode = "en"
        let expectedURL = try XCTUnwrap(URL(
            string: "/tv/1/season/2/episode/3/images?include_image_language=\(languageCode),null"
        ))

        let url = TVEpisodesEndpoint.images(
            tvSeriesID: 1,
            seasonNumber: 2,
            episodeNumber: 3,
            languageCode: languageCode
        ).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVSeasonVideosEndpointReturnsURL() throws {
        let languageCode = "en"
        let expectedURL = try XCTUnwrap(URL(
            string: "/tv/1/season/2/episode/3/videos?include_video_language=\(languageCode),null"
        ))

        let url = TVEpisodesEndpoint.videos(
            tvSeriesID: 1,
            seasonNumber: 2,
            episodeNumber: 3,
            languageCode: languageCode
        ).path

        XCTAssertEqual(url, expectedURL)
    }

}
