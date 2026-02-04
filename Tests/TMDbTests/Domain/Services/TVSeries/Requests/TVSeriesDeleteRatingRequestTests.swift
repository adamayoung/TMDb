//
//  TVSeriesDeleteRatingRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .tvSeries))
struct TVSeriesDeleteRatingRequestTests {

    @Test("path is correct")
    func path() {
        let request = TVSeriesDeleteRatingRequest(tvSeriesID: 1, sessionID: "abc123")

        #expect(request.path == "/tv/1/rating")
    }

    @Test("queryItems contains sessionID")
    func queryItemsContainsSessionID() {
        let request = TVSeriesDeleteRatingRequest(tvSeriesID: 1, sessionID: "abc123")

        #expect(request.queryItems.count == 1)
        #expect(request.queryItems["session_id"] == "abc123")
    }

    @Test("method is DELETE")
    func methodIsDelete() {
        let request = TVSeriesDeleteRatingRequest(tvSeriesID: 1, sessionID: "abc123")

        #expect(request.method == .delete)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = TVSeriesDeleteRatingRequest(tvSeriesID: 1, sessionID: "abc123")

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = TVSeriesDeleteRatingRequest(tvSeriesID: 1, sessionID: "abc123")

        #expect(request.body == nil)
    }

}
