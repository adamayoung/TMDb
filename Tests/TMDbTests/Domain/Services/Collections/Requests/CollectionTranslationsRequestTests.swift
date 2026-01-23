//
//  CollectionTranslationsRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.requests, .collection))
struct CollectionTranslationsRequestTests {

    @Test("path is correct")
    func path() {
        let request = CollectionTranslationsRequest(id: 10)

        #expect(request.path == "/collection/10/translations")
    }

    @Test("queryItems is empty")
    func queryItemsIsEmpty() {
        let request = CollectionTranslationsRequest(id: 10)

        #expect(request.queryItems.isEmpty)
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = CollectionTranslationsRequest(id: 10)

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = CollectionTranslationsRequest(id: 10)

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = CollectionTranslationsRequest(id: 10)

        #expect(request.body == nil)
    }

}
