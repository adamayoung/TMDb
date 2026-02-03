//
//  PersonTVSeriesCreditsRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .people))
struct PersonTVSeriesCreditsRequestTests {

    @Test("path is correct")
    func path() {
        let request = PersonTVSeriesCreditsRequest(id: 1)

        #expect(request.path == "/person/1/tv_credits")
    }

    @Test("queryItems is empty")
    func queryItemsIsEmpty() {
        let request = PersonTVSeriesCreditsRequest(id: 1)

        #expect(request.queryItems.isEmpty)
    }

    @Test("queryItems with language")
    func queryItemsWithLanguage() {
        let request = PersonTVSeriesCreditsRequest(id: 1, language: "en")

        #expect(request.queryItems == ["language": "en"])
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = PersonTVSeriesCreditsRequest(id: 1)

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = PersonTVSeriesCreditsRequest(id: 1)

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = PersonTVSeriesCreditsRequest(id: 1)

        #expect(request.body == nil)
    }

}
