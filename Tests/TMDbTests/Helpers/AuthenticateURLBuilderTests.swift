//
//  AuthenticateURLBuilderTests.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
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

@testable import TMDb
import XCTest

final class AuthenticateURLBuilderTests: XCTestCase {

    var builder: AuthenticateURLBuilder!
    var baseURL: URL!

    override func setUp() {
        super.setUp()
        baseURL = URL(string: "https://some.domain.com")
        builder = AuthenticateURLBuilder(baseURL: baseURL)
    }

    override func tearDown() {
        builder = nil
        baseURL = nil
        super.tearDown()
    }

    func testAuthenticateURLReturnsURL() {
        let requestToken = "qwertyuiop"
        let expectedURL = baseURL
            .appendingPathComponent("authenticate")
            .appendingPathComponent(requestToken)

        let url = builder.authenticateURL(with: requestToken)

        XCTAssertEqual(url, expectedURL)
    }

    func testAuthenticateURLWithRedirectURLReturnsURL() throws {
        let requestToken = "qwertyuiop"
        let redirectURL = try XCTUnwrap(URL(string: "https://my.domain.com/auth/callback"))
        let expectedURL = baseURL
            .appendingPathComponent("authenticate")
            .appendingPathComponent(requestToken)
            .appendingQueryItem(name: "redirect_to", value: redirectURL.absoluteString)

        let url = builder.authenticateURL(with: requestToken, redirectURL: redirectURL)

        XCTAssertEqual(url, expectedURL)
    }

}
