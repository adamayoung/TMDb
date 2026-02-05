//
//  CompanySearchRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .search))
struct CompanySearchRequestTests {

    @Test("path is correct")
    func path() {
        let request = CompanySearchRequest(query: "")

        #expect(request.path == "/search/company")
    }

    @Test("queryItems with query")
    func queryItemsWithQuery() {
        let request = CompanySearchRequest(query: "marvel")

        #expect(request.queryItems == ["query": "marvel"])
    }

    @Test("queryItems with query and page")
    func queryItemsWithQueryAndPage() {
        let request = CompanySearchRequest(
            query: "marvel", page: 3
        )

        #expect(
            request.queryItems
                == ["query": "marvel", "page": "3"]
        )
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = CompanySearchRequest(query: "")

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = CompanySearchRequest(query: "")

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = CompanySearchRequest(query: "")

        #expect(request.body == nil)
    }

}
