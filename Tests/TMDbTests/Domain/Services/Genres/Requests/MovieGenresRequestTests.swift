//
//  MovieGenresRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.requests, .genre))
struct MovieGenresRequestTests {

    @Test("path is correct")
    func path() {
        let request = MovieGenresRequest()

        #expect(request.path == "/genre/movie/list")
    }

    @Test("queryItems is empty")
    func queryItemsIsEmpty() {
        let request = MovieGenresRequest()

        #expect(request.queryItems.isEmpty)
    }

    @Test("queryItems with language")
    func queryItemsWithLanguage() {
        let request = MovieGenresRequest(language: "en")

        #expect(request.queryItems == ["language": "en"])
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = MovieGenresRequest()

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = MovieGenresRequest()

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = MovieGenresRequest()

        #expect(request.body == nil)
    }

}
