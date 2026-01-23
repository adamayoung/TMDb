//
//  WatchProvidersForTVSeriesRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.requests, .watchProvider))
struct WatchProvidersForTVSeriesRequestTests {

    @Test("path is correct")
    func path() {
        let request = WatchProvidersForTVSeriesRequest()

        #expect(request.path == "/watch/providers/tv")
    }

    @Test("queryItems is empty")
    func queryItemsIsEmpty() {
        let request = WatchProvidersForTVSeriesRequest()

        #expect(request.queryItems.isEmpty)
    }

    @Test("queryItems with country")
    func queryItemsWithCountry() {
        let request = WatchProvidersForTVSeriesRequest(country: "GB")

        #expect(request.queryItems == ["watch_region": "GB"])
    }

    @Test("queryItems with language")
    func queryItemsWithLanguage() {
        let request = WatchProvidersForTVSeriesRequest(language: "en")

        #expect(request.queryItems == ["language": "en"])
    }

    @Test("queryItems with country and language")
    func queryItemsWithCountryAndLanguage() {
        let request = WatchProvidersForTVSeriesRequest(country: "GB", language: "en")

        #expect(request.queryItems == ["watch_region": "GB", "language": "en"])
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = WatchProvidersForTVSeriesRequest()

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = WatchProvidersForTVSeriesRequest()

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = WatchProvidersForTVSeriesRequest()

        #expect(request.body == nil)
    }

}
