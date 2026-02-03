//
//  TVSeriesWatchlistRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .account))
struct TVSeriesWatchlistRequestTests {

    @Test("path is correct")
    func path() {
        let request = TVSeriesWatchlistRequest(accountID: 1, sessionID: "abc")

        #expect(request.path == "/account/1/watchlist/tv")
    }

    @Test("queryItems contains session_id")
    func queryItemsContainsSessionID() {
        let request = TVSeriesWatchlistRequest(accountID: 1, sessionID: "abc")

        #expect(request.queryItems == ["session_id": "abc"])
    }

    @Test("queryItems contains sort_by and session_id")
    func queryItemsContainsSortByAndSessionID() {
        let request = TVSeriesWatchlistRequest(
            sortedBy: .createdAt(descending: false), accountID: 1, sessionID: "abc"
        )

        #expect(request.queryItems == ["sort_by": "created_at.asc", "session_id": "abc"])
    }

    @Test("queryItems contains page and session_id")
    func queryItemsContainsPageAndSessionID() {
        let request = TVSeriesWatchlistRequest(page: 2, accountID: 1, sessionID: "abc")

        #expect(request.queryItems == ["page": "2", "session_id": "abc"])
    }

    @Test("queryItems contains sort_by, page and session_id")
    func queryItemsContainsSortByAndPageAndSessionID() {
        let request = TVSeriesWatchlistRequest(
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
        let request = TVSeriesWatchlistRequest(accountID: 1, sessionID: "abc")

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = TVSeriesWatchlistRequest(accountID: 1, sessionID: "abc")

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = TVSeriesWatchlistRequest(accountID: 1, sessionID: "abc")

        #expect(request.body == nil)
    }

}
