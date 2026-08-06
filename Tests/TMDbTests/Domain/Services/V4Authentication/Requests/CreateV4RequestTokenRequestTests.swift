//
//  CreateV4RequestTokenRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .authentication))
struct CreateV4RequestTokenRequestTests {

    @Test("path is the v4 request-token endpoint")
    func pathReturnsURL() {
        let request = CreateV4RequestTokenRequest()

        #expect(request.path == "/auth/request_token")
    }

    @Test("method is POST")
    func methodIsPost() {
        let request = CreateV4RequestTokenRequest()

        #expect(request.method == .post)
    }

    @Test("queryItems are empty")
    func queryItemsAreEmpty() {
        let request = CreateV4RequestTokenRequest()

        #expect(request.queryItems.isEmpty)
    }

    @Test("body omits redirect when no redirect URL is given")
    func bodyWithoutRedirectURL() {
        let request = CreateV4RequestTokenRequest()

        #expect(request.body?.redirectTo == nil)
    }

    @Test("body carries the redirect URL when one is given")
    func bodyWithRedirectURL() throws {
        let redirectURL = try #require(URL(string: "https://my.domain.com/auth/callback"))

        let request = CreateV4RequestTokenRequest(redirectURL: redirectURL)

        #expect(request.body?.redirectTo == "https://my.domain.com/auth/callback")
    }

}
