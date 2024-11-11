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

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.models))
struct SessionTests {

    @Test("JSON decoding of Session", .tags(.decoding))
    func testDecodeReturnsSession() throws {
        let expectedResult = Session(
            success: true,
            sessionID: "5f038ae0ee88737033fb7371dfbf6e3f386e9c78"
        )

        let result = try JSONDecoder.theMovieDatabaseAuth.decode(
            Session.self, fromResource: "session")

        #expect(result.success == expectedResult.success)
        #expect(result.sessionID == expectedResult.sessionID)
    }

}
