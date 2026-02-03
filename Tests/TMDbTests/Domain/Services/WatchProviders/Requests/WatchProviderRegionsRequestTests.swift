//
//  WatchProviderRegionsRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .watchProvider))
struct WatchProviderRegionsRequestTests {

    var request: WatchProviderRegionsRequest!

    init() {
        self.request = WatchProviderRegionsRequest()
    }

    @Test("path is correct")
    func path() {
        let request = WatchProviderRegionsRequest()

        #expect(request.path == "/watch/providers/regions")
    }

    @Test("queryItems is empty")
    func queryItemsIsEmpty() {
        let request = WatchProviderRegionsRequest()

        #expect(request.queryItems.isEmpty)
    }

    @Test("queryItems with language")
    func queryItemsWithLanguage() {
        let request = WatchProviderRegionsRequest(language: "en")

        #expect(request.queryItems == ["language": "en"])
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = WatchProviderRegionsRequest()

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = WatchProviderRegionsRequest()

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = WatchProviderRegionsRequest()

        #expect(request.body == nil)
    }

}
