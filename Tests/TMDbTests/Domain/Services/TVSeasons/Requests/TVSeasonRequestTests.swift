//
//  TVSeasonRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.requests, .tvSeason))
struct TVSeasonRequestTests {

    @Test("path is correct")
    func path() {
        let request = TVSeasonRequest(seasonNumber: 2, tvSeriesID: 3)

        #expect(request.path == "/tv/3/season/2")
    }

    @Test("queryItems is empty")
    func queryItemsIsEmpty() {
        let request = TVSeasonRequest(seasonNumber: 2, tvSeriesID: 3)

        #expect(request.queryItems.isEmpty)
    }

    @Test("queryItems with language")
    func queryItemsWithLanguage() {
        let request = TVSeasonRequest(seasonNumber: 2, tvSeriesID: 3, language: "en")

        #expect(request.queryItems == ["language": "en"])
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = TVSeasonRequest(seasonNumber: 2, tvSeriesID: 3)

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = TVSeasonRequest(seasonNumber: 2, tvSeriesID: 3)

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = TVSeasonRequest(seasonNumber: 2, tvSeriesID: 3)

        #expect(request.body == nil)
    }

}
