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

    func testPathReturnsURL() throws {
        let expectedPath = try XCTUnwrap(URL(string: "/discover/tv"))

        let request = DiscoverTVSeriesRequest()

        XCTAssertEqual(request.path, expectedPath)
    }

    func testPathWithSortedByReturnsURL() throws {
        let expectedPath = try XCTUnwrap(URL(string: "/discover/tv?sort_by=first_air_date.asc"))

        let request = DiscoverTVSeriesRequest(sortedBy: .firstAirDate(descending: false))

        XCTAssertEqual(request.path, expectedPath)
    }

    func testPathWithPageReturnsURL() throws {
        let expectedPath = try XCTUnwrap(URL(string: "/discover/tv?page=1"))

        let request = DiscoverTVSeriesRequest(page: 1)

        XCTAssertEqual(request.path, expectedPath)
    }

    func testTVSeriesEndpointWithSortedByAndPageReturnsURL() throws {
        let expectedPath = try XCTUnwrap(URL(string: "/discover/tv?sort_by=first_air_date.asc&page=1"))

        let request = DiscoverTVSeriesRequest(sortedBy: .firstAirDate(descending: false), page: 1)

        XCTAssertEqual(request.path, expectedPath)
    }

    func testMethodIsGet() {
        let request = DiscoverTVSeriesRequest()

        XCTAssertEqual(request.method, .get)
    }

    func testHeadersIsEmpty() {
        let request = DiscoverTVSeriesRequest()

        XCTAssertEqual(request.headers, [:])
    }

    func testBodyIsNil() {
        let request = DiscoverTVSeriesRequest()

        XCTAssertNil(request.body)
    }

    func testSerialiserIsTMDbJSON() {
        let request = DiscoverTVSeriesRequest()

        XCTAssertTrue(request.serialiser is TMDbJSONSerialiser)
    }

}
