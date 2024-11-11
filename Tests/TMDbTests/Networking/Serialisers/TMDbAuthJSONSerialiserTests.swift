//
//  TMDbAuthJSONSerialiserTests.swift
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

@Suite(.tags(.networking))
struct TMDbAuthSerialiserTests {

    var serialiser: Serialiser!

    init() {
        self.serialiser = TMDbAuthJSONSerialiser()
    }

    @Test("decode when data cannot be decoded throws decode error")
    func decodeWhenDataCannotBeDecodedThrowsDecodeError() async throws {
        let data = Data("aaa".utf8)

        await #expect(throws: Error.self) {
            _ = try await serialiser.decode(MockObject.self, from: data)
        }
    }

    @Test("decode when data can be decoded returns decoded object")
    func decodeWhenDataCanBeDecodedReturnsDecodedObject() async throws {
        let expectedResult = MockObject()
        let data = expectedResult.data

        let result = try await serialiser.decode(MockObject.self, from: data)

        #expect(result == expectedResult)
    }

    @Test("encode when data cannot be encoded throws encode error")
    func encodeWhenDataCannotBeEncodedThrowsEncodeError() async throws {
        let data = Data()

        await #expect(throws: Error.self) {
            _ = try await serialiser.decode(MockObject.self, from: data)
        }
    }

    @Test("encode when data can be encoded returns data")
    func encodeWhenDataCanBeEncodedReturnsData() async throws {
        let value = MockObject()
        let expectedResult = value.data

        let result = try await serialiser.encode(value)

        #expect(result == expectedResult)
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
