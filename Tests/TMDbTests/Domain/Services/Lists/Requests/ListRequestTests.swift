//
//  ListRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .list))
struct ListRequestTests {

    @Test("path is correct")
    func path() {
        let request = ListRequest(id: 123, page: nil)

        #expect(request.path == "/list/123")
    }

    @Test("queryItems with no page")
    func queryItemsWithNoPage() {
        let request = ListRequest(id: 123, page: nil)

        #expect(request.queryItems.isEmpty)
    }

    @Test("queryItems with page parameter")
    func queryItemsWithPageParameter() {
        let request = ListRequest(id: 123, page: 2)

        #expect(request.queryItems == ["page": "2"])
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = ListRequest(id: 123, page: nil)

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = ListRequest(id: 123, page: nil)

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = ListRequest(id: 123, page: nil)

        #expect(request.body == nil)
    }

}
