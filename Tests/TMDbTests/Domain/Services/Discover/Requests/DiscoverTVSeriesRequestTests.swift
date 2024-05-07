//
//  DiscoverTVSeriesRequestTests.swift
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

final class DiscoverTVSeriesRequestTests: XCTestCase {

    func testPath() {
        let request = DiscoverTVSeriesRequest()

        XCTAssertEqual(request.path, "/discover/tv")
    }

    func testQueryItemsWithSortedBy() {
        let request = DiscoverTVSeriesRequest(sortedBy: .firstAirDate(descending: false))

        XCTAssertEqual(request.queryItems["sort_by"], "first_air_date.asc")
    }

    func testQueryItemsWithPage() throws {
        let request = DiscoverTVSeriesRequest(page: 1)

        XCTAssertEqual(request.queryItems["page"], "1")
    }

    func testQueryItemsWithLanguage() {
        let request = DiscoverMoviesRequest(language: "en")

        XCTAssertEqual(request.queryItems["language"], "en")
    }

    func testMethodIsGet() {
        let request = DiscoverTVSeriesRequest()

        XCTAssertEqual(request.method, .get)
    }

    func testHeadersIsEmpty() {
        let request = DiscoverTVSeriesRequest()

        XCTAssertTrue(request.headers.isEmpty)
    }

    func testBodyIsNil() {
        let request = DiscoverTVSeriesRequest()

        XCTAssertNil(request.body)
    }

}
