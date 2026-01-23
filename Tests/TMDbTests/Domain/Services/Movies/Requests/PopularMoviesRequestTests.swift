//
//  PopularMoviesRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.requests, .movie))
struct PopularMoviesRequestTests {

    @Test("path is correct")
    func path() {
        let request = PopularMoviesRequest()

        #expect(request.path == "/movie/popular")
    }

    @Test("queryItems is empty")
    func queryItemsIsEmpty() {
        let request = PopularMoviesRequest()

        #expect(request.queryItems.isEmpty)
    }

    @Test("queryItems with page")
    func queryItemsWithPage() {
        let request = PopularMoviesRequest(page: 3)

        #expect(request.queryItems == ["page": "3"])
    }

    @Test("queryItems with language")
    func queryItemsWithLanguage() {
        let request = PopularMoviesRequest(language: "en")

        #expect(request.queryItems == ["language": "en"])
    }

    @Test("queryItems with country")
    func queryItemsWithCountry() {
        let request = PopularMoviesRequest(country: "GB")

        #expect(request.queryItems == ["region": "GB"])
    }

    @Test("queryItems with page, language and country")
    func queryItemsWithPageAndLanguageAndCountry() {
        let request = PopularMoviesRequest(page: 3, country: "GB", language: "en")

        #expect(request.queryItems == ["page": "3", "language": "en", "region": "GB"])
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = PopularMoviesRequest()

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = PopularMoviesRequest()

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = PopularMoviesRequest()

        #expect(request.body == nil)
    }

}
