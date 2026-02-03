//
//  MovieCreditsRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .movie))
struct MovieCreditsRequestTests {

    @Test("path is correct")
    func path() {
        let request = MovieCreditsRequest(id: 1)

        #expect(request.path == "/movie/1/credits")
    }

    @Test("queryItems is empty")
    func queryItemsIsEmpty() {
        let request = MovieCreditsRequest(id: 1)

        #expect(request.queryItems.isEmpty)
    }

    @Test("queryItems with language")
    func queryItemsWithLanguage() {
        let request = MovieCreditsRequest(id: 1, language: "en")

        #expect(request.queryItems == ["language": "en"])
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = MovieCreditsRequest(id: 1)

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = MovieCreditsRequest(id: 1)

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = MovieCreditsRequest(id: 1)

        #expect(request.body == nil)
    }

}
