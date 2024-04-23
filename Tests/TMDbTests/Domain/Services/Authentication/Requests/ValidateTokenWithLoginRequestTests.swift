//
//  AddFavouriteRequestTests.swift
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

final class ValidateTokenWithLoginRequestTests: XCTestCase {

    var request: ValidateTokenWithLoginRequest!

    override func setUp() {
        super.setUp()
        request = ValidateTokenWithLoginRequest(
            username: "user1",
            password: "pass1",
            requestToken: "abc123"
        )
    }

    override func tearDown() {
        request = nil
        super.tearDown()
    }

    func testPath() {
        XCTAssertEqual(request.path, "/authentication/token/validate_with_login")
    }

    func testQueryItemsIsEmpty() {
        XCTAssertTrue(request.queryItems.isEmpty)
    }

    func testMethodIsPost() {
        XCTAssertEqual(request.method, .post)
    }

    func testHeadersIsEmpty() {
        XCTAssertTrue(request.headers.isEmpty)
    }

    func testBodyWhenMovieAndAddingAsFavourite() throws {
        let body = try XCTUnwrap(request.body)

        XCTAssertEqual(body.username, "user1")
        XCTAssertEqual(body.password, "pass1")
        XCTAssertEqual(body.requestToken, "abc123")
    }

    func testSerialiserIsTMDbJSON() {
        XCTAssertTrue(request.serialiser is TMDbAuthJSONSerialiser)
    }

}
