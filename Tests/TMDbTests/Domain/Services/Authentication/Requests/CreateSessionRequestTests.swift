//
//  CreateSessionRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.requests, .authentication))
struct CreateSessionRequestTests {

    var request: CreateSessionRequest!

    init() {
        self.request = CreateSessionRequest(requestToken: "ABC123")
    }

    @Test("path is correct")
    func path() {
        #expect(request.path == "/authentication/session/new")
    }

    @Test("queryItems is empty")
    func queryItemsIsEmpty() {
        #expect(request.queryItems.isEmpty)
    }

    @Test("method is POST")
    func methodIsPost() {
        #expect(request.method == .post)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        #expect(request.headers.isEmpty)
    }

    @Test("body contains requestToken")
    func bodyContainsRequestToken() throws {
        let body = try #require(request.body)

        #expect(body.requestToken == "ABC123")
    }

}
