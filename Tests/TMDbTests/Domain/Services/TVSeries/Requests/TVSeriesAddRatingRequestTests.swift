//
//  TVSeriesAddRatingRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .tvSeries))
struct TVSeriesAddRatingRequestTests {

    @Test("path is correct")
    func path() {
        let request = TVSeriesAddRatingRequest(rating: 8.5, tvSeriesID: 1, sessionID: "abc123")

        #expect(request.path == "/tv/1/rating")
    }

    @Test("queryItems contains sessionID")
    func queryItemsContainsSessionID() {
        let request = TVSeriesAddRatingRequest(rating: 8.5, tvSeriesID: 1, sessionID: "abc123")

        #expect(request.queryItems.count == 1)
        #expect(request.queryItems["session_id"] == "abc123")
    }

    @Test("method is POST")
    func methodIsPost() {
        let request = TVSeriesAddRatingRequest(rating: 8.5, tvSeriesID: 1, sessionID: "abc123")

        #expect(request.method == .post)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = TVSeriesAddRatingRequest(rating: 8.5, tvSeriesID: 1, sessionID: "abc123")

        #expect(request.headers.isEmpty)
    }

    @Test("body contains rating value")
    func bodyContainsRating() {
        let request = TVSeriesAddRatingRequest(rating: 8.5, tvSeriesID: 1, sessionID: "abc123")

        #expect(request.body == RatingBody(value: 8.5))
    }

}
