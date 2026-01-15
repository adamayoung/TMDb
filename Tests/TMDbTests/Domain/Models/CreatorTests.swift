//
//  CreatorTests.swift
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
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.models))
struct CreatorTests {

    @Test("id decodes correctly", .tags(.decoding))
    func testIDDecodesCorrectly() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(Creator.self, fromResource: "creator")

        #expect(result.id == 9813)
    }

    @Test("creditID decodes correctly", .tags(.decoding))
    func testCreditIDDecodesCorrectly() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(Creator.self, fromResource: "creator")

        #expect(result.creditID == "5256c8c219c2956ff604858a")
    }

    @Test("name decodes correctly", .tags(.decoding))
    func testNameDecodesCorrectly() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(Creator.self, fromResource: "creator")

        #expect(result.name == "David Benioff")
    }

    @Test("originalName decodes correctly", .tags(.decoding))
    func testOriginalNameDecodesCorrectly() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(Creator.self, fromResource: "creator")

        #expect(result.originalName == "David Benioff")
    }

    @Test("gender decodes correctly", .tags(.decoding))
    func testGenderDecodesCorrectly() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(Creator.self, fromResource: "creator")

        #expect(result.gender == .male)
    }

    @Test("profilePath decodes correctly", .tags(.decoding))
    func testProfilePathDecodesCorrectly() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(Creator.self, fromResource: "creator")

        #expect(result.profilePath == URL(string: "/xvNN5huL0X8yJ7h3IZfGG4O2zBD.jpg"))
    }

}
