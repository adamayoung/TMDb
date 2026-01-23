//
//  TokenTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.models))
struct TokenTests {

    @Test("JSON decoding of Token", .tags(.decoding))
    func decodeReturnsToken() throws {
        let expectedResult = Token(
            success: true,
            requestToken: "10530f2246e244555d122016db7c65599c8d6f4d",
            expiresAt: Date(timeIntervalSince1970: 1_705_956_596)
        )

        let result = try JSONDecoder.theMovieDatabaseAuth.decode(
            Token.self, fromResource: "request-token"
        )

        #expect(result.success == expectedResult.success)
        #expect(result.requestToken == expectedResult.requestToken)
        #expect(result.expiresAt == expectedResult.expiresAt)
    }

}
