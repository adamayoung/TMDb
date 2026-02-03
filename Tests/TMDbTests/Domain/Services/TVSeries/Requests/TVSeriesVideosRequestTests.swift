//
//  TVSeriesVideosRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .tvSeries))
struct TVSeriesVideosRequestTests {

    @Test("path is correct")
    func path() {
        let request = TVSeriesVideosRequest(id: 1)

        #expect(request.path == "/tv/1/videos")
    }

    @Test("queryItems is empty")
    func queryItemsIsEmpty() {
        let request = TVSeriesVideosRequest(id: 1)

        #expect(request.queryItems.isEmpty)
    }

    @Test("queryItems with languages")
    func queryItemsWithLanguages() {
        let request = TVSeriesVideosRequest(id: 1, languages: ["en-GB", "fr"])

        #expect(request.queryItems == ["include_video_language": "en-GB,fr"])
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = TVSeriesVideosRequest(id: 1)

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = TVSeriesVideosRequest(id: 1)

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = TVSeriesVideosRequest(id: 1)

        #expect(request.body == nil)
    }

}
