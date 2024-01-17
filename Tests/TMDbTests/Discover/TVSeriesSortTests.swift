//
//  TVSeriesSortTests.swift
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

final class TVSeriesSortTests: XCTestCase {

    func testPopularityAscendingReturnsRawValue() {
        let expectedResult = "popularity.asc"

        let result = TVSeriesSort.popularity(descending: false).description

        XCTAssertEqual(result, expectedResult)
    }

    func testPopularityDescendingReturnsRawValue() {
        let expectedResult = "popularity.desc"

        let result = TVSeriesSort.popularity(descending: true).description

        XCTAssertEqual(result, expectedResult)
    }

    func testFirstAirDateAscendingReturnsRawValue() {
        let expectedResult = "first_air_date.asc"

        let result = TVSeriesSort.firstAirDate(descending: false).description

        XCTAssertEqual(result, expectedResult)
    }

    func testFirstAirDateDescendingReturnsRawValue() {
        let expectedResult = "first_air_date.desc"

        let result = TVSeriesSort.firstAirDate(descending: true).description

        XCTAssertEqual(result, expectedResult)
    }

    func testVoteAverageAscendingReturnsRawValue() {
        let expectedResult = "vote_average.asc"

        let result = TVSeriesSort.voteAverage(descending: false).description

        XCTAssertEqual(result, expectedResult)
    }

    func testVoteAverageDescendingReturnsRawValue() {
        let expectedResult = "vote_average.desc"

        let result = TVSeriesSort.voteAverage(descending: true).description

        XCTAssertEqual(result, expectedResult)
    }

}

extension TVSeriesSortTests {

    func testURLAppendingSortByReturnsURL() throws {
        let expectedResult = try XCTUnwrap(URL(string: "/some/path?sort_by=popularity.asc"))

        let result = try XCTUnwrap(URL(string: "/some/path"))
            .appendingSortBy(TVSeriesSort.popularity(descending: false))

        XCTAssertEqual(result, expectedResult)
    }

    func testURLAppendingNilSortByReturnsURL() throws {
        let expectedResult = try XCTUnwrap(URL(string: "/some/path"))

        let result = try XCTUnwrap(URL(string: "/some/path"))
            .appendingSortBy(nil as TVSeriesSort?)

        XCTAssertEqual(result, expectedResult)
    }

}
