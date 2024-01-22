//
//  GuestSessionTests.swift
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

final class GuestSessionTests: XCTestCase {

    func testDecodeReturnsGuestSession() throws {
        let expectedResult = GuestSession(
            success: true,
            guestSessionID: "hg8r6c2clzw06bdtjt3whqghd44pki46",
            expiresAt: Date(timeIntervalSince1970: 1_705_956_596)
        )

        let result = try JSONDecoder.theMovieDatabaseAuth.decode(GuestSession.self, fromResource: "guest-session")

        XCTAssertEqual(result.success, expectedResult.success)
        XCTAssertEqual(result.guestSessionID, expectedResult.guestSessionID)
        XCTAssertEqual(result.expiresAt, expectedResult.expiresAt)
    }

}
