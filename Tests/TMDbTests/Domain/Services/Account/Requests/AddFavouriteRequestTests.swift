//
//  AddFavouriteRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .account))
struct AddFavouriteRequestTests {

    @Test("path is correct")
    func path() {
        let request = AddFavouriteRequest(
            showType: .movie,
            showID: 1,
            isFavourite: true,
            accountID: 1,
            sessionID: "abc"
        )

        #expect(request.path == "/account/1/favorite")
    }

    @Test("queryItems contains session_id")
    func queryItemsContainsSessionID() {
        let request = AddFavouriteRequest(
            showType: .movie,
            showID: 1,
            isFavourite: true,
            accountID: 1,
            sessionID: "abc"
        )

        #expect(request.queryItems == ["session_id": "abc"])
    }

    @Test("method is POST")
    func methodIsPost() {
        let request = AddFavouriteRequest(
            showType: .movie,
            showID: 1,
            isFavourite: true,
            accountID: 1,
            sessionID: "abc"
        )

        #expect(request.method == .post)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = AddFavouriteRequest(
            showType: .movie,
            showID: 1,
            isFavourite: true,
            accountID: 1,
            sessionID: "abc"
        )

        #expect(request.headers.isEmpty)
    }

    @Test("body when movie and adding as favourite")
    func bodyWhenMovieAndAddingAsFavourite() throws {
        let request = AddFavouriteRequest(
            showType: .movie,
            showID: 1,
            isFavourite: true,
            accountID: 1,
            sessionID: "abc"
        )

        let body = try #require(request.body)

        #expect(body.showType == .movie)
        #expect(body.showID == 1)
        #expect(body.isFavourite)
    }

    @Test("body when movie and removing as favourite")
    func bodyWhenMovieAndRemovingAsFavourite() throws {
        let request = AddFavouriteRequest(
            showType: .movie,
            showID: 2,
            isFavourite: false,
            accountID: 1,
            sessionID: "abc"
        )

        let body = try #require(request.body)

        #expect(body.showType == .movie)
        #expect(body.showID == 2)
        #expect(!body.isFavourite)
    }

    @Test("body when TV series and adding as favourite")
    func bodyWhenTVSeriesAndAddingAsFavourite() throws {
        let request = AddFavouriteRequest(
            showType: .tvSeries,
            showID: 3,
            isFavourite: true,
            accountID: 1,
            sessionID: "abc"
        )

        let body = try #require(request.body)

        #expect(body.showType == .tvSeries)
        #expect(body.showID == 3)
        #expect(body.isFavourite)
    }

    @Test("body when TV series and removing as favourite")
    func bodyWhenTVSeriesAndRemovingAsFavourite() throws {
        let request = AddFavouriteRequest(
            showType: .tvSeries,
            showID: 4,
            isFavourite: false,
            accountID: 1,
            sessionID: "abc"
        )

        let body = try #require(request.body)

        #expect(body.showType == .tvSeries)
        #expect(body.showID == 4)
        #expect(!body.isFavourite)
    }

}
