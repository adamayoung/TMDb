//
//  TVEpisodeImagesRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .tvEpisode))
struct TVEpisodeImagesRequestTests {

    @Test("path is correct")
    func path() {
        let request = TVEpisodeImagesRequest(episodeNumber: 1, seasonNumber: 2, tvSeriesID: 3)

        #expect(request.path == "/tv/3/season/2/episode/1/images")
    }

    @Test("queryItems is empty")
    func queryItemsIsEmpty() {
        let request = TVEpisodeImagesRequest(episodeNumber: 1, seasonNumber: 2, tvSeriesID: 3)

        #expect(request.queryItems.isEmpty)
    }

    @Test("queryItems with languages")
    func queryItemsWithLanguages() {
        let request = TVEpisodeImagesRequest(
            episodeNumber: 1,
            seasonNumber: 2,
            tvSeriesID: 3,
            languages: ["en-GB", "fr"]
        )

        #expect(request.queryItems == ["include_image_language": "en,fr,null"])
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = TVEpisodeImagesRequest(episodeNumber: 1, seasonNumber: 2, tvSeriesID: 3)

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = TVEpisodeImagesRequest(episodeNumber: 1, seasonNumber: 2, tvSeriesID: 3)

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = TVEpisodeImagesRequest(episodeNumber: 1, seasonNumber: 2, tvSeriesID: 3)

        #expect(request.body == nil)
    }

}
