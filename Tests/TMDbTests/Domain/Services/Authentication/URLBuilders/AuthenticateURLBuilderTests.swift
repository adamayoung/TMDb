//
//  AuthenticateURLBuilderTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.authentication))
struct AuthenticateURLBuilderTests {

    var builder: AuthenticateURLBuilder!
    var baseURL: URL!

    init() {
        self.baseURL = URL(string: "https://some.domain.com")
        self.builder = AuthenticateURLBuilder(baseURL: baseURL)
    }

    @Test("authenticateURL returns URL")
    func authenticateURLReturnsURL() {
        let requestToken = "qwertyuiop"
        let expectedURL =
            baseURL
                .appendingPathComponent("authenticate")
                .appendingPathComponent(requestToken)

        let url = builder.authenticateURL(with: requestToken)

        #expect(url == expectedURL)
    }

    @Test("authenticateURL with redirect URL returns URL")
    func authenticateURLWithRedirectURLReturnsURL() throws {
        let requestToken = "qwertyuiop"
        let redirectURL = try #require(URL(string: "https://my.domain.com/auth/callback"))
        let expectedURL = try #require(
            URL(
                string:
                "https://some.domain.com/authenticate/\(requestToken)?redirect_to=\(redirectURL.absoluteString)"
            )
        )

        let url = builder.authenticateURL(with: requestToken, redirectURL: redirectURL)

        #expect(url == expectedURL)
    }

}
