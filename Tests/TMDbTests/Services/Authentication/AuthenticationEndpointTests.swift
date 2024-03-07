//
//  AuthenticationEndpointTests.swift
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

final class AuthenticationEndpointTests: XCTestCase {

    func testCreateGuestSessionEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/authentication/guest_session/new"))

        let url = AuthenticationEndpoint.createGuestSession.path

        XCTAssertEqual(url, expectedURL)
    }

    func testCreateRequetTokenEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/authentication/token/new"))

        let url = AuthenticationEndpoint.createRequestToken.path

        XCTAssertEqual(url, expectedURL)
    }

    func testCreateSessionEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/authentication/session/new"))

        let url = AuthenticationEndpoint.createSession.path

        XCTAssertEqual(url, expectedURL)
    }

    func testCreateSessionWithLoginEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/authentication/token/validate_with_login"))

        let url = AuthenticationEndpoint.createSessionWithLogin.path

        XCTAssertEqual(url, expectedURL)
    }

}
