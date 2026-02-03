//
//  WatchProvidersForMoviesRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .watchProvider))
struct WatchProvidersForMoviesRequestTests {

    @Test("path is correct")
    func path() {
        let request = WatchProvidersForMoviesRequest()

        #expect(request.path == "/watch/providers/movie")
    }

    @Test("queryItems is empty")
    func queryItemsIsEmpty() {
        let request = WatchProvidersForMoviesRequest()

        #expect(request.queryItems.isEmpty)
    }

    @Test("queryItems with country")
    func queryItemsWithCountry() {
        let request = WatchProvidersForMoviesRequest(country: "GB")

        #expect(request.queryItems == ["watch_region": "GB"])
    }

    @Test("queryItems with language")
    func queryItemsWithLanguage() {
        let request = WatchProvidersForMoviesRequest(language: "en")

        #expect(request.queryItems == ["language": "en"])
    }

    @Test("queryItems with country and language")
    func queryItemsWithCountryAndLanguage() {
        let request = WatchProvidersForMoviesRequest(country: "GB", language: "en")

        #expect(request.queryItems == ["watch_region": "GB", "language": "en"])
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = WatchProvidersForMoviesRequest()

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = WatchProvidersForMoviesRequest()

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = WatchProvidersForMoviesRequest()

        #expect(request.body == nil)
    }

}
