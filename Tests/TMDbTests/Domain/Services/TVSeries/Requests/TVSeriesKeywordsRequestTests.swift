//
//  TVSeriesKeywordsRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .tvSeries))
struct TVSeriesKeywordsRequestTests {

    @Test("path is correct")
    func path() {
        let request = TVSeriesKeywordsRequest(id: 1)

        #expect(request.path == "/tv/1/keywords")
    }

    @Test("queryItems is empty")
    func queryItemsIsEmpty() {
        let request = TVSeriesKeywordsRequest(id: 1)

        #expect(request.queryItems.isEmpty)
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = TVSeriesKeywordsRequest(id: 1)

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = TVSeriesKeywordsRequest(id: 1)

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = TVSeriesKeywordsRequest(id: 1)

        #expect(request.body == nil)
    }

}
