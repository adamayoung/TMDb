//
//  KeywordSearchRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .search))
struct KeywordSearchRequestTests {

    @Test("path is correct")
    func path() {
        let request = KeywordSearchRequest(query: "")

        #expect(request.path == "/search/keyword")
    }

    @Test("queryItems with query")
    func queryItemsWithQuery() {
        let request = KeywordSearchRequest(query: "marvel")

        #expect(request.queryItems == ["query": "marvel"])
    }

    @Test("queryItems with query and page")
    func queryItemsWithQueryAndPage() {
        let request = KeywordSearchRequest(
            query: "marvel", page: 3
        )

        #expect(
            request.queryItems
                == ["query": "marvel", "page": "3"]
        )
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = KeywordSearchRequest(query: "")

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = KeywordSearchRequest(query: "")

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = KeywordSearchRequest(query: "")

        #expect(request.body == nil)
    }

}
