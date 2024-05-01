//
//  FavouriteMoviesRequestTests.swift
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

final class FavouriteMoviesRequestTests: XCTestCase {

    func testPath() {
        let request = FavouriteMoviesRequest(accountID: 1, sessionID: "abc")

        XCTAssertEqual(request.path, "/account/1/favorite/movies")
    }

    func testQueryItemsContainsSessionID() {
        let request = FavouriteMoviesRequest(accountID: 1, sessionID: "abc")

        XCTAssertEqual(request.queryItems.count, 1)
        XCTAssertEqual(request.queryItems["session_id"], "abc")
    }

    func testQueryItemsContainsSortedByAndSessionID() {
        let request = FavouriteMoviesRequest(sortedBy: .createdAt(descending: false), accountID: 1, sessionID: "abc")

        XCTAssertEqual(request.queryItems.count, 2)
        XCTAssertEqual(request.queryItems["sort_by"], "created_at.asc")
        XCTAssertEqual(request.queryItems["session_id"], "abc")
    }

    func testQueryItemsContainsPageAndSessionID() {
        let request = FavouriteMoviesRequest(page: 2, accountID: 1, sessionID: "abc")

        XCTAssertEqual(request.queryItems.count, 2)
        XCTAssertEqual(request.queryItems["page"], "2")
        XCTAssertEqual(request.queryItems["session_id"], "abc")
    }

    func testQueryItemsContainsSortedByAndPageAndSessionID() {
        let request = FavouriteMoviesRequest(
            sortedBy: .createdAt(descending: true),
            page: 2,
            accountID: 1,
            sessionID: "abc"
        )

        XCTAssertEqual(request.queryItems.count, 3)
        XCTAssertEqual(request.queryItems["sort_by"], "created_at.desc")
        XCTAssertEqual(request.queryItems["page"], "2")
        XCTAssertEqual(request.queryItems["session_id"], "abc")
    }

    func testMethodIsGet() {
        let request = FavouriteMoviesRequest(accountID: 1, sessionID: "abc")

        XCTAssertEqual(request.method, .get)
    }

    func testHeadersIsEmpty() {
        let request = FavouriteMoviesRequest(accountID: 1, sessionID: "abc")

        XCTAssertTrue(request.headers.isEmpty)
    }

    func testBodyIsNil() {
        let request = FavouriteMoviesRequest(accountID: 1, sessionID: "abc")

        XCTAssertNil(request.body)
    }

}
