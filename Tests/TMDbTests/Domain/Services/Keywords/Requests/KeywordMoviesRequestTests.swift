//
//  KeywordMoviesRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.requests, .keyword))
struct KeywordMoviesRequestTests {

    @Test("path is correct")
    func path() {
        let request = KeywordMoviesRequest(id: 378)

        #expect(request.path == "/keyword/378/movies")
    }

    @Test("queryItems is empty when no parameters")
    func queryItemsIsEmptyWhenNoParameters() {
        let request = KeywordMoviesRequest(id: 378)

        #expect(request.queryItems.isEmpty)
    }

    @Test("queryItems with page")
    func queryItemsWithPage() {
        let request = KeywordMoviesRequest(id: 378, page: 2)

        #expect(request.queryItems == ["page": "2"])
    }

    @Test("queryItems with language")
    func queryItemsWithLanguage() {
        let request = KeywordMoviesRequest(id: 378, language: "en")

        #expect(request.queryItems == ["language": "en"])
    }

    @Test("queryItems with page and language")
    func queryItemsWithPageAndLanguage() {
        let request = KeywordMoviesRequest(id: 378, page: 3, language: "fr")

        #expect(request.queryItems == ["page": "3", "language": "fr"])
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = KeywordMoviesRequest(id: 378)

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = KeywordMoviesRequest(id: 378)

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = KeywordMoviesRequest(id: 378)

        #expect(request.body == nil)
    }

}
