//
//  TMDbAuthJSONSerialiserTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
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
        let data = try expectedResult.data()

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
        let expectedResult = try value.data()

        let result = try await serialiser.encode(value)

        #expect(result == expectedResult)
    }

}

extension TMDbAuthSerialiserTests {

    private struct MockObject: Codable, Equatable {

        let id: UUID

        init(id: UUID = .init()) {
            self.id = id
        }

        func data() throws -> Data {
            try JSONEncoder().encode(self)
        }

    }

}
