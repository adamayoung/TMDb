//
//  CompanyAlternativeNamesRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .company))
struct CompanyAlternativeNamesRequestTests {

    var request: CompanyAlternativeNamesRequest!

    init() {
        self.request = CompanyAlternativeNamesRequest(id: 1)
    }

    @Test("path is correct")
    func path() {
        #expect(request.path == "/company/1/alternative_names")
    }

    @Test("queryItems is empty")
    func queryItemsIsEmpty() {
        #expect(request.queryItems.isEmpty)
    }

    @Test("method is GET")
    func methodIsGet() {
        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        #expect(request.body == nil)
    }

}
