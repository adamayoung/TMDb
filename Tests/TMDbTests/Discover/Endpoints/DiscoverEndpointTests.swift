//
//  DiscoverEndpointTests.swift
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

final class DiscoverEndpointTests: XCTestCase {

    func testMoviesEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/discover/movie"))

        let url = DiscoverEndpoint.movies().path

        XCTAssertEqual(url, expectedURL)
    }

    func testMoviesEndpointWithSortedByReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/discover/movie?sort_by=original_title.asc"))

        let url = DiscoverEndpoint.movies(sortedBy: .originalTitle(descending: false)).path

        XCTAssertEqual(url, expectedURL)
    }

    func testMoviesEndpointWithWithPeopleReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/discover/movie?with_people=1,2,3"))

        let url = DiscoverEndpoint.movies(people: [1, 2, 3]).path

        XCTAssertEqual(url, expectedURL)
    }

    func testMoviesEndpointWithPageReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/discover/movie?page=1"))

        let url = DiscoverEndpoint.movies(page: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testMoviesEndpointWithSortedByAndWithPeopleAndPageReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(
            string: "/discover/movie?sort_by=original_title.asc&with_people=1,2,3&page=1")
        )

        let url = DiscoverEndpoint.movies(sortedBy: .originalTitle(descending: false), people: [1, 2, 3], page: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVSeriesEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/discover/tv"))

        let url = DiscoverEndpoint.tvSeries().path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVSeriesEndpointWithSortedByReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/discover/tv?sort_by=first_air_date.asc"))

        let url = DiscoverEndpoint.tvSeries(sortedBy: .firstAirDate(descending: false)).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVSeriesEndpointWithPageReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/discover/tv?page=1"))

        let url = DiscoverEndpoint.tvSeries(page: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVSeriesEndpointWithSortedByAndPageReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/discover/tv?sort_by=first_air_date.asc&page=1"))

        let url = DiscoverEndpoint.tvSeries(sortedBy: .firstAirDate(descending: false), page: 1).path

        XCTAssertEqual(url, expectedURL)
    }

}
