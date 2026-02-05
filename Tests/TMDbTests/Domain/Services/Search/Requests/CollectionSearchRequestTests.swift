//
//  CollectionSearchRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .search))
struct CollectionSearchRequestTests {

    @Test("path is correct")
    func path() {
        let request = CollectionSearchRequest(query: "")

        #expect(request.path == "/search/collection")
    }

    @Test("queryItems with query")
    func queryItemsWithQuery() {
        let request = CollectionSearchRequest(query: "marvel")

        #expect(request.queryItems == ["query": "marvel"])
    }

    @Test("queryItems with query and page")
    func queryItemsWithQueryAndPage() {
        let request = CollectionSearchRequest(
            query: "marvel", page: 3
        )

        #expect(
            request.queryItems
                == ["query": "marvel", "page": "3"]
        )
    }

    @Test("queryItems with query and language")
    func queryItemsWithQueryAndLanguage() {
        let request = CollectionSearchRequest(
            query: "marvel", language: "en"
        )

        #expect(
            request.queryItems
                == ["query": "marvel", "language": "en"]
        )
    }

    @Test("queryItems with query, page and language")
    func queryItemsWithQueryAndPageAndLanguage() {
        let request = CollectionSearchRequest(
            query: "marvel", page: 2, language: "en"
        )

        #expect(
            request.queryItems == [
                "query": "marvel",
                "page": "2",
                "language": "en"
            ]
        )
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = CollectionSearchRequest(query: "")

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = CollectionSearchRequest(query: "")

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = CollectionSearchRequest(query: "")

        #expect(request.body == nil)
    }

}
