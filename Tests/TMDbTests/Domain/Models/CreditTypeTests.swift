//
//  CreditTypeTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models, .credit))
struct CreditTypeTests {

    @Test("JSON decoding of cast CreditType", .tags(.decoding))
    func decodeCast() throws {
        let data = Data(#""cast""#.utf8)

        let result = try JSONDecoder().decode(
            CreditType.self, from: data
        )

        #expect(result == .cast)
    }

    @Test("JSON decoding of crew CreditType", .tags(.decoding))
    func decodeCrew() throws {
        let data = Data(#""crew""#.utf8)

        let result = try JSONDecoder().decode(
            CreditType.self, from: data
        )

        #expect(result == .crew)
    }

    /// TMDb also returns `credit_type` values outside this enum — a live
    /// example is credit 5257855d19c29531db28adea, which reports "creator".
    /// Decoding one throws today, failing the whole `details(forCredit:)` call.
    /// This test locks that behaviour so making it tolerant is a deliberate,
    /// source-breaking change rather than an accident; tracked in issue #418.
    @Test("JSON decoding of an unknown CreditType throws", .tags(.decoding))
    func decodeUnknownCreditTypeThrows() {
        let data = Data(#""creator""#.utf8)

        #expect(throws: DecodingError.self) {
            _ = try JSONDecoder().decode(
                CreditType.self, from: data
            )
        }
    }

    @Test("JSON encoding of cast CreditType", .tags(.encoding))
    func encodeCast() throws {
        let data = try JSONEncoder().encode(CreditType.cast)
        let result = String(data: data, encoding: .utf8)

        #expect(result == #""cast""#)
    }

    @Test("JSON encoding of crew CreditType", .tags(.encoding))
    func encodeCrew() throws {
        let data = try JSONEncoder().encode(CreditType.crew)
        let result = String(data: data, encoding: .utf8)

        #expect(result == #""crew""#)
    }

}
