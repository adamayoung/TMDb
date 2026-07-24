//
//  TMDbStatusCodeTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct TMDbStatusCodeTests {

    @Test(
        "init(rawValue:) maps documented codes to named cases",
        arguments: [
            (7, TMDbStatusCode.invalidAPIKey),
            (6, TMDbStatusCode.invalidID),
            (34, TMDbStatusCode.resourceNotFound),
            (25, TMDbStatusCode.rateLimitExceeded),
            (1, TMDbStatusCode.success),
            (47, TMDbStatusCode.invalidInput),
            (20, TMDbStatusCode.invalidDateRange)
        ]
    )
    func initWithDocumentedRawValueMapsToNamedCase(rawValue: Int, expected: TMDbStatusCode) throws {
        let statusCode = try #require(TMDbStatusCode(rawValue: rawValue))

        #expect(statusCode == expected)
    }

    @Test("rawValue round-trips for every documented code")
    func rawValueRoundTripsForEveryDocumentedCode() throws {
        for code in 1 ... 47 {
            let statusCode = try #require(TMDbStatusCode(rawValue: code))

            #expect(statusCode.rawValue == code)
        }
    }

    @Test("documented codes never classify to unknown")
    func documentedCodesNeverClassifyToUnknown() throws {
        for code in 1 ... 47 {
            let statusCode = try #require(TMDbStatusCode(rawValue: code))

            if case .unknown = statusCode {
                Issue.record("Code \(code) unexpectedly classified as .unknown")
            }
        }
    }

    @Test("init(rawValue:) falls back to unknown preserving the raw value")
    func initWithUndocumentedRawValueFallsBackToUnknown() throws {
        let statusCode = try #require(TMDbStatusCode(rawValue: 999))

        #expect(statusCode == .unknown(999))
        #expect(statusCode.rawValue == 999)
    }

    @Test("init(rawValue:) never returns nil", arguments: [-1, 0, 48, 1000])
    func initNeverReturnsNil(rawValue: Int) {
        #expect(TMDbStatusCode(rawValue: rawValue) != nil)
    }

    @Test("equality is based on the raw value")
    func equalityIsBasedOnRawValue() {
        // In practice `.unknown` only ever holds an undocumented code, so this
        // collision never arises; equality is by raw value for coherence.
        #expect(TMDbStatusCode.unknown(7) == TMDbStatusCode.invalidAPIKey)
        #expect(TMDbStatusCode.invalidAPIKey == TMDbStatusCode.invalidAPIKey)
    }

    @Test("different codes are not equal")
    func differentCodesAreNotEqual() {
        #expect(TMDbStatusCode.invalidAPIKey != TMDbStatusCode.resourceNotFound)
        #expect(TMDbStatusCode.unknown(999) != TMDbStatusCode.invalidAPIKey)
    }

    @Test("equal status codes hash equally")
    func equalStatusCodesHashEqually() {
        #expect(TMDbStatusCode.rateLimitExceeded.hashValue == TMDbStatusCode.unknown(25).hashValue)
    }

}
