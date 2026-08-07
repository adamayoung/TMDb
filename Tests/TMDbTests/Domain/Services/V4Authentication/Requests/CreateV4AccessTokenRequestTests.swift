//
//  CreateV4AccessTokenRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .authentication))
struct CreateV4AccessTokenRequestTests {

    @Test("path is the v4 access-token endpoint")
    func pathReturnsURL() {
        let request = CreateV4AccessTokenRequest(requestToken: "abc123")

        #expect(request.path == "/auth/access_token")
    }

    @Test("method is POST")
    func methodIsPost() {
        let request = CreateV4AccessTokenRequest(requestToken: "abc123")

        #expect(request.method == .post)
    }

    @Test("body carries the request token")
    func bodyCarriesRequestToken() {
        let request = CreateV4AccessTokenRequest(requestToken: "abc123")

        #expect(request.body?.requestToken == "abc123")
    }

    @Test("body encodes request_token in snake case", .tags(.encoding))
    func bodyEncodesSnakeCase() throws {
        let request = CreateV4AccessTokenRequest(requestToken: "abc123")
        let body = try #require(request.body)

        let data = try JSONEncoder.theMovieDatabase.encode(body)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]

        #expect(json?["request_token"] as? String == "abc123")
    }

}
