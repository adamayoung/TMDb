//
//  PersonTranslationsRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .people))
struct PersonTranslationsRequestTests {

    @Test("path is correct")
    func path() {
        let request = PersonTranslationsRequest(id: 500)

        #expect(request.path == "/person/500/translations")
    }

    @Test("queryItems is empty")
    func queryItemsIsEmpty() {
        let request = PersonTranslationsRequest(id: 500)

        #expect(request.queryItems.isEmpty)
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = PersonTranslationsRequest(id: 500)

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = PersonTranslationsRequest(id: 500)

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = PersonTranslationsRequest(id: 500)

        #expect(request.body == nil)
    }

}
