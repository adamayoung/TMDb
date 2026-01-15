//
//  MediaListItemStatusTests.swift
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
struct MediaListItemStatusTests {

    @Test("JSON decoding when item is present", .tags(.decoding))
    func decodeReturnsMediaListItemStatusWhenItemIsPresent() throws {
        let json = """
            {
              "id": "1",
              "itemPresent": true
            }
            """

        let data = Data(json.utf8)
        let result = try JSONDecoder.theMovieDatabase.decode(
            MediaListItemStatus.self,
            from: data
        )

        #expect(result.id == "1")
        #expect(result.isPresent == true)
    }

    @Test("JSON decoding when item is not present", .tags(.decoding))
    func decodeReturnsMediaListItemStatusWhenItemIsNotPresent() throws {
        let json = """
            {
              "id": "123",
              "itemPresent": false
            }
            """

        let data = Data(json.utf8)
        let result = try JSONDecoder.theMovieDatabase.decode(
            MediaListItemStatus.self,
            from: data
        )

        #expect(result.id == "123")
        #expect(result.isPresent == false)
    }

}
