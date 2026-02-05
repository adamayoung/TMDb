//
//  PersonTaggedImagesRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .people))
struct PersonTaggedImagesRequestTests {

    @Test("path is correct")
    func path() {
        let request = PersonTaggedImagesRequest(id: 500)

        #expect(request.path == "/person/500/tagged_images")
    }

    @Test("queryItems is empty when no page")
    func queryItemsIsEmptyWhenNoPage() {
        let request = PersonTaggedImagesRequest(id: 500)

        #expect(request.queryItems.isEmpty)
    }

    @Test("queryItems with page")
    func queryItemsWithPage() {
        let request = PersonTaggedImagesRequest(
            id: 500, page: 2
        )

        #expect(request.queryItems == ["page": "2"])
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = PersonTaggedImagesRequest(id: 500)

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = PersonTaggedImagesRequest(id: 500)

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = PersonTaggedImagesRequest(id: 500)

        #expect(request.body == nil)
    }

}
