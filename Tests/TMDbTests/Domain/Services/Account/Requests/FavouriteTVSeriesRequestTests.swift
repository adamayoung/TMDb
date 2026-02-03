//
//  FavouriteTVSeriesRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .account))
struct FavouriteTVSeriesRequestTests {

    @Test("path is correct")
    func path() {
        let request = FavouriteTVSeriesRequest(accountID: 1, sessionID: "abc")

        #expect(request.path == "/account/1/favorite/tv")
    }

    @Test("queryItems contains session_id")
    func queryItemsContainsSessionID() {
        let request = FavouriteTVSeriesRequest(accountID: 1, sessionID: "abc")

        #expect(request.queryItems == ["session_id": "abc"])
    }

    @Test("queryItems contains sort_by and session_id")
    func queryItemsContainsSortByAndSessionID() {
        let request = FavouriteTVSeriesRequest(
            sortedBy: .createdAt(descending: false), accountID: 1, sessionID: "abc"
        )

        #expect(request.queryItems == ["sort_by": "created_at.asc", "session_id": "abc"])
    }

    @Test("queryItems contains page and session_id")
    func queryItemsContainsPageAndSessionID() {
        let request = FavouriteTVSeriesRequest(page: 2, accountID: 1, sessionID: "abc")

        #expect(request.queryItems == ["page": "2", "session_id": "abc"])
    }

    @Test("queryItems contains sort_by, page and session_id")
    func queryItemsContainsSortedByAndPageAndSessionID() {
        let request = FavouriteTVSeriesRequest(
            sortedBy: .createdAt(descending: true),
            page: 2,
            accountID: 1,
            sessionID: "abc"
        )

        #expect(
            request.queryItems == ["sort_by": "created_at.desc", "page": "2", "session_id": "abc"]
        )
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = FavouriteTVSeriesRequest(accountID: 1, sessionID: "abc")

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = FavouriteTVSeriesRequest(accountID: 1, sessionID: "abc")

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = FavouriteTVSeriesRequest(accountID: 1, sessionID: "abc")

        #expect(request.body == nil)
    }

}
