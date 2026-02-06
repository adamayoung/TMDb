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
