//
//  MovieReviewsRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .movie))
struct MovieReviewsRequestTests {

    @Test("path is correct")
    func path() {
        let request = MovieReviewsRequest(id: 1)

        #expect(request.path == "/movie/1/reviews")
    }

    @Test("queryItems is empty")
    func queryItemsIsEmpty() {
        let request = MovieReviewsRequest(id: 1)

        #expect(request.queryItems.isEmpty)
    }

    @Test("queryItems with page")
    func queryItemsWithPage() {
        let request = MovieReviewsRequest(id: 1, page: 3)

        #expect(request.queryItems == ["page": "3"])
    }

    @Test("queryItems with language")
    func queryItemsWithLanguage() {
        let request = MovieReviewsRequest(id: 1, language: "en")

        #expect(request.queryItems == ["language": "en"])
    }

    @Test("queryItems with page and language")
    func queryItemsWithPageAndLanguage() {
        let request = MovieReviewsRequest(id: 1, page: 3, language: "en")

        #expect(request.queryItems == ["page": "3", "language": "en"])
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = MovieReviewsRequest(id: 1)

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = MovieReviewsRequest(id: 1)

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = MovieReviewsRequest(id: 1)

        #expect(request.body == nil)
    }

}
