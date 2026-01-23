//
//  TVSeriesReviewsRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.requests, .tvSeries))
struct TVSeriesReviewsRequestTests {

    @Test("path is correct")
    func path() {
        let request = TVSeriesReviewsRequest(id: 1)

        #expect(request.path == "/tv/1/reviews")
    }

    @Test("queryItems is empty")
    func queryItemsIsEmpty() {
        let request = TVSeriesReviewsRequest(id: 1)

        #expect(request.queryItems.isEmpty)
    }

    @Test("queryItems with page")
    func queryItemsWithPage() {
        let request = TVSeriesReviewsRequest(id: 1, page: 3)

        #expect(request.queryItems == ["page": "3"])
    }

    @Test("queryItems with language")
    func queryItemsWithLanguage() {
        let request = TVSeriesReviewsRequest(id: 1, language: "en")

        #expect(request.queryItems == ["language": "en"])
    }

    @Test("queryItems with page and language")
    func queryItemsWithPageAndLanguage() {
        let request = TVSeriesReviewsRequest(id: 1, page: 2, language: "en")

        #expect(request.queryItems == ["page": "2", "language": "en"])
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = TVSeriesReviewsRequest(id: 1)

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = TVSeriesReviewsRequest(id: 1)

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = TVSeriesReviewsRequest(id: 1)

        #expect(request.body == nil)
    }

}
