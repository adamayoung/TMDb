//
//  TVSeriesGenresRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.requests, .genre))
struct TVSeriesGenresRequestTests {

    @Test("path is correct")
    func path() {
        let request = TVSeriesGenresRequest()

        #expect(request.path == "/genre/tv/list")
    }

    @Test("queryItems is empty")
    func queryItemsIsEmpty() {
        let request = TVSeriesGenresRequest()

        #expect(request.queryItems.isEmpty)
    }

    @Test("queryItems with language")
    func queryItemsWithLanguage() {
        let request = TVSeriesGenresRequest(language: "en")

        #expect(request.queryItems == ["language": "en"])
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = TVSeriesGenresRequest()

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = TVSeriesGenresRequest()

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = TVSeriesGenresRequest()

        #expect(request.body == nil)
    }

}
