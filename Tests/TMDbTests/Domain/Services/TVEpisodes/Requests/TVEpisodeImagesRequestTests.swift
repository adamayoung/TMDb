//
//  TVEpisodeImagesRequestTests.swift
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

final class TVEpisodeImagesRequestTests: XCTestCase {

    func testPath() {
        let request = TVEpisodeImagesRequest(episodeNumber: 1, seasonNumber: 2, tvSeriesID: 3)

        XCTAssertEqual(request.path, "/tv/3/season/2/episode/1/images")
    }

    func testQueryItemsWhenLanguageCodeIsNilQueryItemsAreEmpty() {
        let request = TVEpisodeImagesRequest(episodeNumber: 1, seasonNumber: 2, tvSeriesID: 3)

        XCTAssertTrue(request.queryItems.isEmpty)
    }

    func testQueryItemsWhenLanguageCodeQueryItemsHasLanguageCode() {
        let request = TVEpisodeImagesRequest(
            episodeNumber: 1,
            seasonNumber: 2,
            tvSeriesID: 3,
            languages: ["en-GB", "fr"]
        )

        XCTAssertEqual(request.queryItems.count, 1)
        XCTAssertEqual(request.queryItems["include_image_language"], "en,fr,null")
    }

    func testMethodIsGet() {
        let request = TVEpisodeImagesRequest(episodeNumber: 1, seasonNumber: 2, tvSeriesID: 3)

        XCTAssertEqual(request.method, .get)
    }

    func testHeadersIsEmpty() {
        let request = TVEpisodeImagesRequest(episodeNumber: 1, seasonNumber: 2, tvSeriesID: 3)

        XCTAssertTrue(request.headers.isEmpty)
    }

    func testBodyIsNil() {
        let request = TVEpisodeImagesRequest(episodeNumber: 1, seasonNumber: 2, tvSeriesID: 3)

        XCTAssertNil(request.body)
    }

}
