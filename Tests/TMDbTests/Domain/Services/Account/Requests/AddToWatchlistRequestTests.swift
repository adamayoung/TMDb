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

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .account))
struct AddToWatchlistRequestTests {

    @Test("path")
    func path() {
        let request = AddToWatchlistRequest(
            showType: .movie,
            showID: 1,
            isInWatchlist: true,
            accountID: 1,
            sessionID: "abc"
        )

        #expect(request.path == "/account/1/watchlist")
    }

    @Test("queryItems contains session_id")
    func queryItemsContainsSessionID() {
        let request = AddToWatchlistRequest(
            showType: .movie,
            showID: 1,
            isInWatchlist: true,
            accountID: 1,
            sessionID: "abc"
        )

        #expect(request.queryItems == ["session_id": "abc"])
    }

    @Test("method is POST")
    func methodIsPost() {
        let request = AddToWatchlistRequest(
            showType: .movie,
            showID: 1,
            isInWatchlist: true,
            accountID: 1,
            sessionID: "abc"
        )

        #expect(request.method == .post)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = AddToWatchlistRequest(
            showType: .movie,
            showID: 1,
            isInWatchlist: true,
            accountID: 1,
            sessionID: "abc"
        )

        #expect(request.headers.isEmpty)
    }

    @Test("body when movie and adding as favourite")
    func bodyWhenMovieAndAddingAsFavourite() throws {
        let request = AddToWatchlistRequest(
            showType: .movie,
            showID: 1,
            isInWatchlist: true,
            accountID: 1,
            sessionID: "abc"
        )

        let body = try #require(request.body)

        #expect(body.showType == .movie)
        #expect(body.showID == 1)
        #expect(body.isInWatchlist)
    }

    @Test("body when movie and removing as favourite")
    func bodyWhenMovieAndRemovingAsFavourite() throws {
        let request = AddToWatchlistRequest(
            showType: .movie,
            showID: 2,
            isInWatchlist: false,
            accountID: 1,
            sessionID: "abc"
        )

        let body = try #require(request.body)

        #expect(body.showType == .movie)
        #expect(body.showID == 2)
        #expect(!body.isInWatchlist)
    }

    @Test("body when TV series and adding as favourite")
    func bodyWhenTVSeriesAndAddingAsFavourite() throws {
        let request = AddToWatchlistRequest(
            showType: .tvSeries,
            showID: 3,
            isInWatchlist: true,
            accountID: 1,
            sessionID: "abc"
        )

        let body = try #require(request.body)

        #expect(body.showType == .tvSeries)
        #expect(body.showID == 3)
        #expect(body.isInWatchlist)
    }

    @Test("body when TV series and removing as favourite")
    func bodyWhenTVSeriesAndRemovingAsFavourite() throws {
        let request = AddToWatchlistRequest(
            showType: .tvSeries,
            showID: 4,
            isInWatchlist: false,
            accountID: 1,
            sessionID: "abc"
        )

        let body = try #require(request.body)

        #expect(body.showType == .tvSeries)
        #expect(body.showID == 4)
        #expect(!body.isInWatchlist)
    }

}
