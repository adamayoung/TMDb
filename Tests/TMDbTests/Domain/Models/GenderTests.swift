//
//  GenderTests.swift
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
struct GenderTests {

    @Test("Unknown gender rawValue is 0")
    func unknownGenderRawValue() {
        #expect(Gender.unknown.rawValue == 0)
    }

    @Test("Female gender rawValue is 1")
    func femaleGenderRawValue() {
        #expect(Gender.female.rawValue == 1)
    }

    @Test("Male gender rawValue is 2")
    func maleGenderRawValue() {
        #expect(Gender.male.rawValue == 2)
    }

    @Test("Other gender rawValue is 3")
    func otherGenderRawValue() {
        #expect(Gender.other.rawValue == 3)
    }

    @Test("JSON decoding of invalid gender raw value", .tags(.decoding))
    func decodeInvalidValueReturnsUnknown() throws {
        let data = Data("{\"gender\": 9}".utf8)
        let decoder = JSONDecoder()

        let result = try decoder.decode(MockObject.self, from: data).gender

        #expect(result == .unknown)
    }

}

extension GenderTests {

    private struct MockObject: Decodable {
        let gender: Gender
    }

}
