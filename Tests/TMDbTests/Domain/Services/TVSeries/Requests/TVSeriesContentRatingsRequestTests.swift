//
//  TVSeriesContentRatingsRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .tvSeries))
struct TVSeriesContentRatingsRequestTests {

    @Test("path is correct")
    func path() {
        let request = ContentRatingRequest(id: 1)

        #expect(request.path == "/tv/1/content_ratings")
    }

    @Test("queryItem is empty")
    func queryItemsIsEmpty() {
        let request = ContentRatingRequest(id: 1)

        #expect(request.queryItems.isEmpty)
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = ContentRatingRequest(id: 1)

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = ContentRatingRequest(id: 1)

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = ContentRatingRequest(id: 1)

        #expect(request.body == nil)
    }

}
