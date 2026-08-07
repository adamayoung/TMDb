//
//  DeleteV4AccessTokenRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .authentication))
struct DeleteV4AccessTokenRequestTests {

    @Test("path is the v4 access-token endpoint")
    func pathReturnsURL() {
        let request = DeleteV4AccessTokenRequest(accessToken: "abc123")

        #expect(request.path == "/auth/access_token")
    }

    @Test("method is DELETE")
    func methodIsDelete() {
        let request = DeleteV4AccessTokenRequest(accessToken: "abc123")

        #expect(request.method == .delete)
    }

    @Test("body carries the access token")
    func bodyCarriesAccessToken() {
        let request = DeleteV4AccessTokenRequest(accessToken: "abc123")

        #expect(request.body?.accessToken == "abc123")
    }

    @Test("body encodes access_token in snake case", .tags(.encoding))
    func bodyEncodesSnakeCase() throws {
        let request = DeleteV4AccessTokenRequest(accessToken: "abc123")
        let body = try #require(request.body)

        let data = try JSONEncoder.theMovieDatabase.encode(body)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]

        #expect(json?["access_token"] as? String == "abc123")
    }

}
