//
//  AddFavouriteRequestTests.swift
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

final class AddFavouriteRequestTests: XCTestCase {

    func testPath() {
        let request = AddFavouriteRequest(
            showType: .movie,
            showID: 1,
            isFavourite: true,
            accountID: 1,
            sessionID: "abc"
        )

        XCTAssertEqual(request.path, "/account/1/favorite")
    }

    func testQueryItemsContainsSessionID() {
        let request = AddFavouriteRequest(
            showType: .movie,
            showID: 1,
            isFavourite: true,
            accountID: 1,
            sessionID: "abc"
        )

        XCTAssertEqual(request.queryItems.count, 1)
        XCTAssertEqual(request.queryItems["session_id"], "abc")
    }

    func testMethodIsPost() {
        let request = AddFavouriteRequest(
            showType: .movie,
            showID: 1,
            isFavourite: true,
            accountID: 1,
            sessionID: "abc"
        )

        XCTAssertEqual(request.method, .post)
    }

    func testHeadersIsEmpty() {
        let request = AddFavouriteRequest(
            showType: .movie,
            showID: 1,
            isFavourite: true,
            accountID: 1,
            sessionID: "abc"
        )

        XCTAssertTrue(request.headers.isEmpty)
    }

    func testBodyWhenMovieAndAddingAsFavourite() throws {
        let request = AddFavouriteRequest(
            showType: .movie,
            showID: 1,
            isFavourite: true,
            accountID: 1,
            sessionID: "abc"
        )

        let body = try XCTUnwrap(request.body)

        XCTAssertEqual(body.showType, .movie)
        XCTAssertEqual(body.showID, 1)
        XCTAssertTrue(body.isFavourite)
    }

    func testBodyWhenMovieAndRemovingAsFavourite() throws {
        let request = AddFavouriteRequest(
            showType: .movie,
            showID: 2,
            isFavourite: false,
            accountID: 1,
            sessionID: "abc"
        )

        let body = try XCTUnwrap(request.body)

        XCTAssertEqual(body.showType, .movie)
        XCTAssertEqual(body.showID, 2)
        XCTAssertFalse(body.isFavourite)
    }

    func testBodyWhenTVSeriesAndAddingAsFavourite() throws {
        let request = AddFavouriteRequest(
            showType: .tvSeries,
            showID: 3,
            isFavourite: true,
            accountID: 1,
            sessionID: "abc"
        )

        let body = try XCTUnwrap(request.body)

        XCTAssertEqual(body.showType, .tvSeries)
        XCTAssertEqual(body.showID, 3)
        XCTAssertTrue(body.isFavourite)
    }

    func testBodyWhenTVSeriesAndRemovingAsFavourite() throws {
        let request = AddFavouriteRequest(
            showType: .tvSeries,
            showID: 4,
            isFavourite: false,
            accountID: 1,
            sessionID: "abc"
        )

        let body = try XCTUnwrap(request.body)

        XCTAssertEqual(body.showType, .tvSeries)
        XCTAssertEqual(body.showID, 4)
        XCTAssertFalse(body.isFavourite)
    }

}
