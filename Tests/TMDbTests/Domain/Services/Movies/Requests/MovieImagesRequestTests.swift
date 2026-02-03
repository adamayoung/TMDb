//
//  MovieImagesRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .movie))
struct MovieImagesRequestTests {

    @Test("path is correct")
    func path() {
        let request = MovieImagesRequest(id: 1)

        #expect(request.path == "/movie/1/images")
    }

    @Test("queryItems is empty")
    func queryItemsIsEmpty() {
        let request = MovieImagesRequest(id: 1)

        #expect(request.queryItems.isEmpty)
    }

    @Test("queryItems with language")
    func queryItemsWithLanguage() {
        let request = MovieImagesRequest(id: 1, languages: ["en-GB", "fr"])

        #expect(request.queryItems == ["include_image_language": "en,fr,null"])
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = MovieImagesRequest(id: 1)

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = MovieImagesRequest(id: 1)

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = MovieImagesRequest(id: 1)

        #expect(request.body == nil)
    }

}
