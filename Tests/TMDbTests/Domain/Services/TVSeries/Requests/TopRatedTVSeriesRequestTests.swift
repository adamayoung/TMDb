//
//  TopRatedTVSeriesRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.requests, .tvSeries))
struct TopRatedTVSeriesRequestTests {

    @Test("path is correct")
    func path() {
        let request = TopRatedTVSeriesRequest()

        #expect(request.path == "/tv/top_rated")
    }

    @Test("queryItems is empty")
    func queryItemsIsEmpty() {
        let request = TopRatedTVSeriesRequest()

        #expect(request.queryItems.isEmpty)
    }

    @Test("queryItems with page")
    func queryItemsWithPage() {
        let request = TopRatedTVSeriesRequest(page: 3)

        #expect(request.queryItems == ["page": "3"])
    }

    @Test("queryItems with language")
    func queryItemsWithLanguage() {
        let request = TopRatedTVSeriesRequest(language: "en")

        #expect(request.queryItems == ["language": "en"])
    }

    @Test("queryItems with page and language")
    func queryItemsWithPageAndLanguage() {
        let request = TopRatedTVSeriesRequest(page: 3, language: "en")

        #expect(request.queryItems == ["page": "3", "language": "en"])
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = TopRatedTVSeriesRequest()

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = TopRatedTVSeriesRequest()

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = TopRatedTVSeriesRequest()

        #expect(request.body == nil)
    }

}
