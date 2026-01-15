//
//  CreateListResultTests.swift
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

@Suite(.tags(.models))
struct CreateListResultTests {

    @Test("JSON decoding of successful result", .tags(.decoding))
    func decodeReturnsCreateListResultWhenSuccessful() throws {
        let json = """
            {
              "success": true,
              "status_message": "The item/record was created successfully.",
              "status_code": 1,
              "listId": 12345
            }
            """

        let data = Data(json.utf8)
        let result = try JSONDecoder.theMovieDatabase.decode(CreateListResult.self, from: data)

        #expect(result.success == true)
        #expect(result.statusMessage == "The item/record was created successfully.")
        #expect(result.statusCode == 1)
        #expect(result.listID == 12345)
    }

    @Test("JSON decoding of failed result", .tags(.decoding))
    func decodeReturnsCreateListResultWhenFailed() throws {
        let json = """
            {
              "success": false,
              "status_message": "Invalid API key",
              "status_code": 7,
              "listId": 0
            }
            """

        let data = Data(json.utf8)
        let result = try JSONDecoder.theMovieDatabase.decode(CreateListResult.self, from: data)

        #expect(result.success == false)
        #expect(result.statusMessage == "Invalid API key")
        #expect(result.statusCode == 7)
        #expect(result.listID == 0)
    }

}
