//
//  SessionTests.swift
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

final class SessionTests: XCTestCase {

    func testDecodeReturnsSession() throws {
        let expectedResult = Session(
            success: true,
            sessionID: "5f038ae0ee88737033fb7371dfbf6e3f386e9c78"
        )

        let result = try JSONDecoder.theMovieDatabaseAuth.decode(Session.self, fromResource: "session")

        XCTAssertEqual(result.success, expectedResult.success)
        XCTAssertEqual(result.sessionID, expectedResult.sessionID)
    }

}
