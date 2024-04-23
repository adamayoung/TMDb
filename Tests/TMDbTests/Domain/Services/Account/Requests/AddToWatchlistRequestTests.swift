//
//  AddToWatchlistRequestTests.swift
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

final class AddToWatchlistRequestTests: XCTestCase {

    func testPath() {
        let request = AddToWatchlistRequest(
            showType: .movie,
            showID: 1,
            isInWatchlist: true,
            accountID: 1,
            sessionID: "abc"
        )

        XCTAssertEqual(request.path, "/account/1/watchlist")
    }

    func testQueryItemsContainsSessionID() {
        let request = AddToWatchlistRequest(
            showType: .movie,
            showID: 1,
            isInWatchlist: true,
            accountID: 1,
            sessionID: "abc"
        )

        XCTAssertEqual(request.queryItems.count, 1)
        XCTAssertEqual(request.queryItems["session_id"], "abc")
    }

    func testMethodIsPost() {
        let request = AddToWatchlistRequest(
            showType: .movie,
            showID: 1,
            isInWatchlist: true,
            accountID: 1,
            sessionID: "abc"
        )

        XCTAssertEqual(request.method, .post)
    }

    func testHeadersIsEmpty() {
        let request = AddToWatchlistRequest(
            showType: .movie,
            showID: 1,
            isInWatchlist: true,
            accountID: 1,
            sessionID: "abc"
        )

        XCTAssertTrue(request.headers.isEmpty)
    }

    func testBodyWhenMovieAndAddingAsFavourite() throws {
        let request = AddToWatchlistRequest(
            showType: .movie,
            showID: 1,
            isInWatchlist: true,
            accountID: 1,
            sessionID: "abc"
        )

        let body = try XCTUnwrap(request.body)

        XCTAssertEqual(body.showType, .movie)
        XCTAssertEqual(body.showID, 1)
        XCTAssertTrue(body.isInWatchlist)
    }

    func testBodyWhenMovieAndRemovingAsFavourite() throws {
        let request = AddToWatchlistRequest(
            showType: .movie,
            showID: 2,
            isInWatchlist: false,
            accountID: 1,
            sessionID: "abc"
        )

        let body = try XCTUnwrap(request.body)

        XCTAssertEqual(body.showType, .movie)
        XCTAssertEqual(body.showID, 2)
        XCTAssertFalse(body.isInWatchlist)
    }

    func testBodyWhenTVSeriesAndAddingAsFavourite() throws {
        let request = AddToWatchlistRequest(
            showType: .tvSeries,
            showID: 3,
            isInWatchlist: true,
            accountID: 1,
            sessionID: "abc"
        )

        let body = try XCTUnwrap(request.body)

        XCTAssertEqual(body.showType, .tvSeries)
        XCTAssertEqual(body.showID, 3)
        XCTAssertTrue(body.isInWatchlist)
    }

    func testBodyWhenTVSeriesAndRemovingAsFavourite() throws {
        let request = AddToWatchlistRequest(
            showType: .tvSeries,
            showID: 4,
            isInWatchlist: false,
            accountID: 1,
            sessionID: "abc"
        )

        let body = try XCTUnwrap(request.body)

        XCTAssertEqual(body.showType, .tvSeries)
        XCTAssertEqual(body.showID, 4)
        XCTAssertFalse(body.isInWatchlist)
    }

    func testSerialiserIsTMDbJSON() {
        let request = AddToWatchlistRequest(
            showType: .movie,
            showID: 1,
            isInWatchlist: true,
            accountID: 1,
            sessionID: "abc"
        )

        XCTAssertTrue(request.serialiser is TMDbJSONSerialiser)
    }

}
