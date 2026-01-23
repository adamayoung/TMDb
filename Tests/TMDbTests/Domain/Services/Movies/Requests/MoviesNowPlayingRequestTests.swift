//
//  MoviesNowPlayingRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.requests, .movie))
struct MoviesNowPlayingRequestTests {

    @Test("path is correct")
    func path() {
        let request = MoviesNowPlayingRequest()

        #expect(request.path == "/movie/now_playing")
    }

    @Test("queryItems is empty")
    func queryItemsIsEmpty() {
        let request = MoviesNowPlayingRequest()

        #expect(request.queryItems.isEmpty)
    }

    @Test("queryItems with page")
    func queryItemsWithPage() {
        let request = MoviesNowPlayingRequest(page: 3)

        #expect(request.queryItems == ["page": "3"])
    }

    @Test("queryItems with language")
    func queryItemsWithLanguage() {
        let request = MoviesNowPlayingRequest(language: "en")

        #expect(request.queryItems == ["language": "en"])
    }

    @Test("queryItems with country")
    func queryItemsWithCountry() {
        let request = MoviesNowPlayingRequest(country: "GB")

        #expect(request.queryItems == ["region": "GB"])
    }

    @Test("queryItems with page, language and country")
    func queryItemsWithPageAndLanguageAndCountry() {
        let request = MoviesNowPlayingRequest(page: 3, country: "GB", language: "en")

        #expect(request.queryItems == ["page": "3", "language": "en", "region": "GB"])
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = MoviesNowPlayingRequest()

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = MoviesNowPlayingRequest()

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = MoviesNowPlayingRequest()

        #expect(request.body == nil)
    }

}
