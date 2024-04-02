//
//  TMDbSerialiserTests.swift
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

final class TMDbAuthSerialiserTests: XCTestCase {

    var serialiser: Serialiser!

    override func setUp() {
        super.setUp()
        serialiser = TMDbAuthJSONSerialiser()
    }

    override func tearDown() {
        serialiser = nil
        super.tearDown()
    }

    func testDecodeWhenDataCannotBeDecodedThrowsDecodeError() async throws {
        let data = Data("aaa".utf8)

        var error: Error?
        do {
            _ = try await serialiser.decode(MockObject.self, from: data)
        } catch let decodeError {
            error = decodeError
        }

        XCTAssertNotNil(error)
    }

    func testDecodeWhenDataCanBeDecodedReturnsDecodedObject() async throws {
        let expectedResult = MockObject()
        let data = expectedResult.data

        let result = try await serialiser.decode(MockObject.self, from: data)

        XCTAssertEqual(result, expectedResult)
    }

    func testEncodeWhenDataCannotBeEncodedThrowsEncodeError() async throws {
        let data = Data()

        var error: Error?
        do {
            _ = try await serialiser.decode(MockObject.self, from: data)
        } catch let decodeError {
            error = decodeError
        }

        XCTAssertNotNil(error)
    }

    func testEncodeWhenDataCanBeEncodedReturnsData() async throws {
        let value = MockObject()
        let expectedResult = value.data

        let result = try await serialiser.encode(value)

        XCTAssertEqual(result, expectedResult)
    }

}

extension TMDbAuthSerialiserTests {

    private struct MockObject: Codable, Equatable {

        let id: UUID

        var data: Data {
            // swiftlint:disable force_try
            try! JSONEncoder().encode(self)
            // swiftlint:enable force_try
        }

        init(id: UUID = .init()) {
            self.id = id
        }
    }

}
