//
//  GenderTests.swift
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

final class GenderTests: XCTestCase {

    func testUnknownGenderReturnsRawValue() {
        XCTAssertEqual(Gender.unknown.rawValue, 0)
    }

    func testFemaleGenderReturnsRawValue() {
        XCTAssertEqual(Gender.female.rawValue, 1)
    }

    func testMaleGenderReturnsRawValue() {
        XCTAssertEqual(Gender.male.rawValue, 2)
    }

    func testOtherGenderReturnsRawValue() {
        XCTAssertEqual(Gender.other.rawValue, 3)
    }

    func testDecodeWhenInvalidValueReturnsUnknown() throws {
        let data = Data("{\"gender\": 9}".utf8)
        let decoder = JSONDecoder()

        let result = try decoder.decode(MockObject.self, from: data).gender

        XCTAssertEqual(result, .unknown)
    }

}

extension GenderTests {

    private struct MockObject: Decodable {
        let gender: Gender
    }

}
