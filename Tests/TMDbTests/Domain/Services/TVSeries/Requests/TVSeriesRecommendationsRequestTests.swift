//
//  TVSeriesRecommendationsRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.requests, .tvSeries))
struct TVSeriesRecommendationsRequestTests {

    @Test("path is correct")
    func path() {
        let request = TVSeriesRecommendationsRequest(id: 1)

        #expect(request.path == "/tv/1/recommendations")
    }

    @Test("queryItem is empty")
    func queryItemsIsEmpty() {
        let request = TVSeriesRecommendationsRequest(id: 1)

        #expect(request.queryItems.isEmpty)
    }

    @Test("queryItems with page")
    func queryItemsWithPage() {
        let request = TVSeriesRecommendationsRequest(id: 1, page: 3)

        #expect(request.queryItems == ["page": "3"])
    }

    @Test("queryItems with language")
    func queryItemsWithLanguage() {
        let request = TVSeriesRecommendationsRequest(id: 1, language: "en")

        #expect(request.queryItems == ["language": "en"])
    }

    @Test("queryItems with page and language")
    func queryItemsWithPageAndLanguage() {
        let request = TVSeriesRecommendationsRequest(id: 1, page: 3, language: "en")

        #expect(request.queryItems == ["page": "3", "language": "en"])
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = TVSeriesRecommendationsRequest(id: 1)

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = TVSeriesRecommendationsRequest(id: 1)

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = TVSeriesRecommendationsRequest(id: 1)

        #expect(request.body == nil)
    }

}
