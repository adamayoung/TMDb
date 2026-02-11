//
//  CreateSessionFromV4AccessTokenRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .authentication))
struct CreateSessionFromV4AccessTokenRequestTests {

    var request: CreateSessionFromV4AccessTokenRequest!

    init() {
        self.request = CreateSessionFromV4AccessTokenRequest(
            accessToken: "v4-token-123"
        )
    }

    @Test("path is correct")
    func path() {
        #expect(request.path == "/authentication/session/convert/4")
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

    @Test("body contains accessToken")
    func bodyContainsAccessToken() throws {
        let body = try #require(request.body)

        #expect(body.accessToken == "v4-token-123")
    }

}
