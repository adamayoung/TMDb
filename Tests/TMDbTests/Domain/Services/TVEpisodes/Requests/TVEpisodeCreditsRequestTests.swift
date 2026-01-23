//
//  TVEpisodeCreditsRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.requests, .tvEpisode))
struct TVEpisodeCreditsRequestTests {

    @Test("path is correct")
    func path() {
        let request = TVEpisodeCreditsRequest(
            episodeNumber: 3,
            seasonNumber: 2,
            tvSeriesID: 1
        )

        #expect(request.path == "/tv/1/season/2/episode/3/credits")
    }

    @Test("queryItems is empty")
    func queryItemsIsEmpty() {
        let request = TVEpisodeCreditsRequest(
            episodeNumber: 3,
            seasonNumber: 2,
            tvSeriesID: 1
        )

        #expect(request.queryItems.isEmpty)
    }

    @Test("queryItems with language")
    func queryItemsWithLanguage() {
        let request = TVEpisodeCreditsRequest(
            episodeNumber: 3,
            seasonNumber: 2,
            tvSeriesID: 1,
            language: "en"
        )

        #expect(request.queryItems == ["language": "en"])
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = TVEpisodeCreditsRequest(
            episodeNumber: 3,
            seasonNumber: 2,
            tvSeriesID: 1
        )

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = TVEpisodeCreditsRequest(
            episodeNumber: 3,
            seasonNumber: 2,
            tvSeriesID: 1
        )

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = TVEpisodeCreditsRequest(
            episodeNumber: 3,
            seasonNumber: 2,
            tvSeriesID: 1
        )

        #expect(request.body == nil)
    }

}
