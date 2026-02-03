//
//  MultiSearchRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .search))
struct MultiSearchRequestTests {

    @Test("path is correct")
    func path() {
        let request = MultiSearchRequest(query: "")

        #expect(request.path == "/search/multi")
    }

    @Test("queryItems with query")
    func queryItemsWithQuery() {
        let request = MultiSearchRequest(query: "fight club")

        #expect(request.queryItems == ["query": "fight club"])
    }

    @Test("queryItems with query and includeAdult")
    func queryItemsWithQueryAndIncludeAdult() {
        let request = MultiSearchRequest(query: "fight club", includeAdult: true)

        #expect(request.queryItems == ["query": "fight club", "include_adult": "true"])
    }

    @Test("queryItems with query and page")
    func queryItemsWithQueryAndPage() {
        let request = MultiSearchRequest(query: "fight club", page: 2)

        #expect(request.queryItems == ["query": "fight club", "page": "2"])
    }

    @Test("queryItems with query and language")
    func queryItemsWithQueryAndLanguage() {
        let request = MultiSearchRequest(query: "fight club", language: "en")

        #expect(request.queryItems == ["query": "fight club", "language": "en"])
    }

    @Test("queryItems with query, page, includeAdult and language")
    func queryItemsWithQueryAndPageAndIncludeAdultAndLanguage() {
        let request = MultiSearchRequest(
            query: "fight club",
            includeAdult: false,
            page: 2,
            language: "en"
        )

        #expect(
            request.queryItems == [
                "query": "fight club",
                "page": "2",
                "include_adult": "false",
                "language": "en"
            ]
        )
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = MultiSearchRequest(query: "")

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = MultiSearchRequest(query: "")

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = MultiSearchRequest(query: "")

        #expect(request.body == nil)
    }

}
