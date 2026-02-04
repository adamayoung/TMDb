//
//  TVSeriesListsRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .tvSeries))
struct TVSeriesListsRequestTests {

    @Test("path is correct")
    func path() {
        let request = TVSeriesListsRequest(id: 1)

        #expect(request.path == "/tv/1/lists")
    }

    @Test("queryItems is empty when no parameters")
    func queryItemsIsEmptyWhenNoParameters() {
        let request = TVSeriesListsRequest(id: 1)

        #expect(request.queryItems.isEmpty)
    }

    @Test("queryItems contains page when provided")
    func queryItemsContainsPage() {
        let request = TVSeriesListsRequest(id: 1, page: 2)

        #expect(request.queryItems.count == 1)
        #expect(request.queryItems["page"] == "2")
    }

    @Test("queryItems contains language when provided")
    func queryItemsContainsLanguage() {
        let request = TVSeriesListsRequest(id: 1, language: "en-US")

        #expect(request.queryItems.count == 1)
        #expect(request.queryItems["language"] == "en-US")
    }

    @Test("queryItems contains page and language when both provided")
    func queryItemsContainsPageAndLanguage() {
        let request = TVSeriesListsRequest(id: 1, page: 2, language: "en-US")

        #expect(request.queryItems.count == 2)
        #expect(request.queryItems["page"] == "2")
        #expect(request.queryItems["language"] == "en-US")
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = TVSeriesListsRequest(id: 1)

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = TVSeriesListsRequest(id: 1)

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = TVSeriesListsRequest(id: 1)

        #expect(request.body == nil)
    }

}
