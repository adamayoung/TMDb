//
//  TVSeriesImagesRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.requests, .tvSeries))
struct TVSeriesImagesRequestTests {

    @Test("path is correct")
    func path() {
        let request = TVSeriesImagesRequest(id: 1)

        #expect(request.path == "/tv/1/images")
    }

    @Test("queryItems is empty")
    func queryItemsIsEmpty() {
        let request = TVSeriesImagesRequest(id: 1)

        #expect(request.queryItems.isEmpty)
    }

    @Test("queryItems with languages")
    func queryItemsWithLanguages() {
        let request = TVSeriesImagesRequest(id: 1, languages: ["en-GB", "fr"])

        #expect(request.queryItems == ["include_image_language": "en,fr,null"])
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = TVSeriesImagesRequest(id: 1)

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = TVSeriesImagesRequest(id: 1)

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = TVSeriesImagesRequest(id: 1)

        #expect(request.body == nil)
    }

}
