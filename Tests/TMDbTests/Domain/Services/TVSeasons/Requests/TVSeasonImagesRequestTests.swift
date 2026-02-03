//
//  TVSeasonImagesRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .tvSeason))
struct TVSeasonImagesRequestTests {

    @Test("path is correct")
    func path() {
        let request = TVSeasonImagesRequest(seasonNumber: 2, tvSeriesID: 3)

        #expect(request.path == "/tv/3/season/2/images")
    }

    @Test("queryItems is empty")
    func queryItemsIsEmpty() {
        let request = TVSeasonImagesRequest(seasonNumber: 2, tvSeriesID: 3)

        #expect(request.queryItems.isEmpty)
    }

    @Test("queryItems with languages")
    func queryItemsWithLanguages() {
        let request = TVSeasonImagesRequest(
            seasonNumber: 2, tvSeriesID: 3, languages: ["en-GB", "fr"]
        )

        #expect(request.queryItems == ["include_image_language": "en,fr,null"])
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = TVSeasonImagesRequest(seasonNumber: 2, tvSeriesID: 3)

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = TVSeasonImagesRequest(seasonNumber: 2, tvSeriesID: 3)

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = TVSeasonImagesRequest(seasonNumber: 2, tvSeriesID: 3)

        #expect(request.body == nil)
    }

}
