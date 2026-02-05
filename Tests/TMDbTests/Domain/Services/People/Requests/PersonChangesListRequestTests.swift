//
//  PersonChangesListRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .people))
struct PersonChangesListRequestTests {

    @Test("path is correct")
    func path() {
        let request = PersonChangesListRequest()

        #expect(request.path == "/person/changes")
    }

    @Test("queryItems is empty when no parameters")
    func queryItemsIsEmptyWhenNoParameters() {
        let request = PersonChangesListRequest()

        #expect(request.queryItems.isEmpty)
    }

    @Test("queryItems with page")
    func queryItemsWithPage() {
        let request = PersonChangesListRequest(page: 2)

        #expect(request.queryItems == ["page": "2"])
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = PersonChangesListRequest()

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = PersonChangesListRequest()

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = PersonChangesListRequest()

        #expect(request.body == nil)
    }

}
