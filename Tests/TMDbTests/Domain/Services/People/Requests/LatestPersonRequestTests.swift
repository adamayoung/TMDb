//
//  LatestPersonRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .people))
struct LatestPersonRequestTests {

    @Test("path is correct")
    func path() {
        let request = LatestPersonRequest()

        #expect(request.path == "/person/latest")
    }

    @Test("queryItems is empty")
    func queryItemsIsEmpty() {
        let request = LatestPersonRequest()

        #expect(request.queryItems.isEmpty)
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = LatestPersonRequest()

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = LatestPersonRequest()

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = LatestPersonRequest()

        #expect(request.body == nil)
    }

}
