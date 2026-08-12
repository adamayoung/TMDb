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

    /// A TV series creator credit — live example: credit
    /// 5257855d19c29531db28adea, Steven Spielberg on *Invasion America*.
    @Test("JSON decoding of creator CreditType", .tags(.decoding))
    func decodeCreator() throws {
        let data = Data(#""creator""#.utf8)

        let result = try JSONDecoder().decode(
            CreditType.self, from: data
        )

        #expect(result == .creator)
    }

    @Test(
        "JSON decoding of an unrecognised CreditType returns unknown",
        .tags(.decoding)
    )
    func decodeWhenUnrecognisedValueReturnsUnknown() throws {
        let data = Data(#""some-new-credit-type""#.utf8)

        let result = try JSONDecoder().decode(
            CreditType.self, from: data
        )

        #expect(result == .unknown)
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

    @Test("JSON encoding of creator CreditType", .tags(.encoding))
    func encodeCreator() throws {
        let data = try JSONEncoder().encode(CreditType.creator)
        let result = String(data: data, encoding: .utf8)

        #expect(result == #""creator""#)
    }

    /// `unknown` carries no TMDb vocabulary, so it round-trips as the literal
    /// `"unknown"` rather than the value that produced it. Asserted so the wire
    /// form is a deliberate choice rather than an accident of case ordering.
    @Test("JSON encoding of unknown CreditType", .tags(.encoding))
    func encodeUnknown() throws {
        let data = try JSONEncoder().encode(CreditType.unknown)
        let result = String(data: data, encoding: .utf8)

        #expect(result == #""unknown""#)
    }

}
