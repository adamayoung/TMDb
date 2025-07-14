//
//  AuthenticateURLBuilderTests.swift
//  TMDb
//
//  Copyright © 2025 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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
