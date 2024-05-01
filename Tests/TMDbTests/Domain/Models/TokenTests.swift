//
//  TokenTests.swift
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

final class TokenTests: XCTestCase {

    func testDecodeReturnsToken() throws {
        let expectedResult = Token(
            success: true,
            requestToken: "10530f2246e244555d122016db7c65599c8d6f4d",
            expiresAt: Date(timeIntervalSince1970: 1_705_956_596)
        )

        let result = try JSONDecoder.theMovieDatabaseAuth.decode(Token.self, fromResource: "request-token")

        XCTAssertEqual(result.success, expectedResult.success)
        XCTAssertEqual(result.requestToken, expectedResult.requestToken)
        XCTAssertEqual(result.expiresAt, expectedResult.expiresAt)
    }

}
