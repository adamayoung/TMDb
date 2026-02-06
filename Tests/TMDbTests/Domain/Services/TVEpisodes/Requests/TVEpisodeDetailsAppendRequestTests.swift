//
//  TVEpisodeDetailsAppendRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .tvEpisode))
struct TVEpisodeDetailsAppendRequestTests {

    @Test("path is correct")
    func path() {
        let request = TVEpisodeDetailsAppendRequest(
            tvSeriesID: 1399,
            seasonNumber: 1,
            episodeNumber: 1,
            appendToResponse: .credits
        )

        #expect(request.path == "/tv/1399/season/1/episode/1")
    }

    @Test("queryItems with single option")
    func queryItemsWithSingleOption() throws {
        let request = TVEpisodeDetailsAppendRequest(
            tvSeriesID: 1399,
            seasonNumber: 1,
            episodeNumber: 1,
            appendToResponse: .credits
        )

        let value = try #require(request.queryItems["append_to_response"])
        #expect(value == "credits")
    }

    @Test("queryItems with multiple options")
    func queryItemsWithMultipleOptions() throws {
        let request = TVEpisodeDetailsAppendRequest(
            tvSeriesID: 1399,
            seasonNumber: 1,
            episodeNumber: 1,
            appendToResponse: [.credits, .images]
        )

        let value = try #require(request.queryItems["append_to_response"])
        let components = Set(value.split(separator: ",").map(String.init))
        #expect(components == ["credits", "images"])
    }

    @Test("queryItems with language")
    func queryItemsWithLanguage() throws {
        let request = TVEpisodeDetailsAppendRequest(
            tvSeriesID: 1399,
            seasonNumber: 1,
            episodeNumber: 1,
            appendToResponse: .credits,
            language: "en"
        )

        let appendValue = try #require(
            request.queryItems["append_to_response"]
        )
        #expect(appendValue == "credits")
        #expect(request.queryItems["language"] == "en")
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = TVEpisodeDetailsAppendRequest(
            tvSeriesID: 1399,
            seasonNumber: 1,
            episodeNumber: 1,
            appendToResponse: .credits
        )

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = TVEpisodeDetailsAppendRequest(
            tvSeriesID: 1399,
            seasonNumber: 1,
            episodeNumber: 1,
            appendToResponse: .credits
        )

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = TVEpisodeDetailsAppendRequest(
            tvSeriesID: 1399,
            seasonNumber: 1,
            episodeNumber: 1,
            appendToResponse: .credits
        )

        #expect(request.body == nil)
    }

}
