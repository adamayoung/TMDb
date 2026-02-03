//
//  PopularPeopleRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .people))
struct PopularPeopleRequestTests {

    @Test("path is correct")
    func path() {
        let request = PopularPeopleRequest()

        #expect(request.path == "/person/popular")
    }

    @Test("queryItems is empty")
    func queryItemsIsEmpty() {
        let request = PopularPeopleRequest()

        #expect(request.queryItems.isEmpty)
    }

    @Test("queryItems with page")
    func queryItemsWithPage() {
        let request = PopularPeopleRequest(page: 3)

        #expect(request.queryItems == ["page": "3"])
    }

    @Test("queryItems with language")
    func queryItemsWithLanguage() {
        let request = PopularPeopleRequest(language: "en")

        #expect(request.queryItems == ["language": "en"])
    }

    @Test("queryItems with page and language")
    func queryItemsWithPageAndLanguage() {
        let request = PopularPeopleRequest(page: 3, language: "en")

        #expect(request.queryItems == ["page": "3", "language": "en"])
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = PopularPeopleRequest()

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = PopularPeopleRequest()

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = PopularPeopleRequest()

        #expect(request.body == nil)
    }

}
