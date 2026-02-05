//
//  PersonChangesRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .people))
struct PersonChangesRequestTests {

    @Test("path is correct")
    func path() {
        let request = PersonChangesRequest(id: 500)

        #expect(request.path == "/person/500/changes")
    }

    @Test("queryItems is empty when no parameters")
    func queryItemsIsEmptyWhenNoParameters() {
        let request = PersonChangesRequest(id: 500)

        #expect(request.queryItems.isEmpty)
    }

    @Test("queryItems with page")
    func queryItemsWithPage() {
        let request = PersonChangesRequest(id: 500, page: 2)

        #expect(request.queryItems == ["page": "2"])
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = PersonChangesRequest(id: 500)

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = PersonChangesRequest(id: 500)

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = PersonChangesRequest(id: 500)

        #expect(request.body == nil)
    }

}
