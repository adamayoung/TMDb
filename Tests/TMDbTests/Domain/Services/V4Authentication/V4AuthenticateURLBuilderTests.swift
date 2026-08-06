//
//  V4AuthenticateURLBuilderTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .authentication))
struct V4AuthenticateURLBuilderTests {

    var builder: V4AuthenticateURLBuilder!
    var baseURL: URL!

    init() {
        self.baseURL = URL(string: "https://some.domain.com")
        self.builder = V4AuthenticateURLBuilder(baseURL: baseURL)
    }

    @Test("authenticateURL returns the v4 approval URL with the token as a query item")
    func authenticateURLReturnsURL() throws {
        let expectedURL = try #require(
            URL(string: "https://some.domain.com/auth/access?request_token=abc123")
        )

        let url = builder.authenticateURL(with: "abc123")

        #expect(url == expectedURL)
    }

    @Test("authenticateURL percent-encodes a token containing URL-unsafe characters")
    func authenticateURLPercentEncodesToken() throws {
        let url = builder.authenticateURL(with: "a b&c=d")

        // The token must survive as a single query-item value rather than
        // splitting into extra parameters.
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        let queryItems = try #require(components.queryItems)
        #expect(queryItems.count == 1)
        #expect(queryItems.first?.name == "request_token")
        #expect(queryItems.first?.value == "a b&c=d")
    }

}
