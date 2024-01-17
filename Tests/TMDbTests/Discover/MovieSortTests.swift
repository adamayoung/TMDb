//
//  MovieSortTests.swift
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

final class MovieSortTests: XCTestCase {

    func testPopularityAscendingReturnsRawValue() {
        let expectedResult = "popularity.asc"

        let result = MovieSort.popularity(descending: false).description

        XCTAssertEqual(result, expectedResult)
    }

    func testPopularityDescendingReturnsRawValue() {
        let expectedResult = "popularity.desc"

        let result = MovieSort.popularity(descending: true).description

        XCTAssertEqual(result, expectedResult)
    }

    func testReleaseDateAscendingReturnsRawValue() {
        let expectedResult = "release_date.asc"

        let result = MovieSort.releaseDate(descending: false).description

        XCTAssertEqual(result, expectedResult)
    }

    func testReleaseDateDescendingReturnsRawValue() {
        let expectedResult = "release_date.desc"

        let result = MovieSort.releaseDate(descending: true).description

        XCTAssertEqual(result, expectedResult)
    }

    func testRevenueAscendingReturnsRawValue() {
        let expectedResult = "revenue.asc"

        let result = MovieSort.revenue(descending: false).description

        XCTAssertEqual(result, expectedResult)
    }

    func testRevenueDescendingReturnsRawValue() {
        let expectedResult = "revenue.desc"

        let result = MovieSort.revenue(descending: true).description

        XCTAssertEqual(result, expectedResult)
    }

    func testPrimaryReleaseDateAscendingAscendingReturnsRawValue() {
        let expectedResult = "primary_release_date.asc"

        let result = MovieSort.primaryReleaseDate(descending: false).description

        XCTAssertEqual(result, expectedResult)
    }

    func testPrimaryReleaseDateDescendingDescendingReturnsRawValue() {
        let expectedResult = "primary_release_date.desc"

        let result = MovieSort.primaryReleaseDate(descending: true).description

        XCTAssertEqual(result, expectedResult)
    }

    func testOriginalTitleAscendingReturnsRawValue() {
        let expectedResult = "original_title.asc"

        let result = MovieSort.originalTitle(descending: false).description

        XCTAssertEqual(result, expectedResult)
    }

    func testOriginalTitleDescendingReturnsRawValue() {
        let expectedResult = "original_title.desc"

        let result = MovieSort.originalTitle(descending: true).description

        XCTAssertEqual(result, expectedResult)
    }

    func testVoteAverageAscendingReturnsRawValue() {
        let expectedResult = "vote_average.asc"

        let result = MovieSort.voteAverage(descending: false).description

        XCTAssertEqual(result, expectedResult)
    }

    func testVoteAverageDescendingReturnsRawValue() {
        let expectedResult = "vote_average.desc"

        let result = MovieSort.voteAverage(descending: true).description

        XCTAssertEqual(result, expectedResult)
    }

    func testVoteCountAscendingReturnsRawValue() {
        let expectedResult = "vote_count.asc"

        let result = MovieSort.voteCount(descending: false).description

        XCTAssertEqual(result, expectedResult)
    }

    func testVoteCountDescendingReturnsRawValue() {
        let expectedResult = "vote_count.desc"

        let result = MovieSort.voteCount(descending: true).description

        XCTAssertEqual(result, expectedResult)
    }

}

extension MovieSortTests {

    func testURLAppendingSortByReturnsURL() throws {
        let expectedResult = try XCTUnwrap(URL(string: "/some/path?sort_by=popularity.asc"))

        let result = try XCTUnwrap(URL(string: "/some/path"))
            .appendingSortBy(MovieSort.popularity(descending: false))

        XCTAssertEqual(result, expectedResult)
    }

    func testURLAppendingNilSortByReturnsURL() throws {
        let expectedResult = try XCTUnwrap(URL(string: "/some/path"))

        let result = try XCTUnwrap(URL(string: "/some/path"))
            .appendingSortBy(nil as MovieSort?)

        XCTAssertEqual(result, expectedResult)
    }

}
