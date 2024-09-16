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

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .account))
struct FavouriteMoviesRequestTests {

    @Test("path")
    func path() {
        let request = FavouriteMoviesRequest(accountID: 1, sessionID: "abc")

        #expect(request.path == "/account/1/favorite/movies")
    }

    @Test("queryItems cotains session_id")
    func queryItemsContainsSessionID() {
        let request = FavouriteMoviesRequest(accountID: 1, sessionID: "abc")

        #expect(request.queryItems == ["session_id": "abc"])
    }

    @Test("queryItems contains sort_by and session_id")
    func queryItemsContainsSortByAndSessionID() {
        let request = FavouriteMoviesRequest(sortedBy: .createdAt(descending: false), accountID: 1, sessionID: "abc")

        #expect(request.queryItems == ["sort_by": "created_at.asc", "session_id": "abc"])
    }

    @Test("queryItems contains page and session_id")
    func queryItemsContainsPageAndSessionID() {
        let request = FavouriteMoviesRequest(page: 2, accountID: 1, sessionID: "abc")

        #expect(request.queryItems == ["page": "2", "session_id": "abc"])
    }

    @Test("queryItems contains sort_by, page and session_id")
    func queryItemsContainsSortByAndPageAndSessionID() {
        let request = FavouriteMoviesRequest(
            sortedBy: .createdAt(descending: true),
            page: 2,
            accountID: 1,
            sessionID: "abc"
        )

        #expect(request.queryItems == ["sort_by": "created_at.desc", "page": "2", "session_id": "abc"])
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = FavouriteMoviesRequest(accountID: 1, sessionID: "abc")

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = FavouriteMoviesRequest(accountID: 1, sessionID: "abc")

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = FavouriteMoviesRequest(accountID: 1, sessionID: "abc")

        #expect(request.body == nil)
    }

}
