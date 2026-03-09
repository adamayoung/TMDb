//
//  WatchMonetizationTypeTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct WatchMonetizationTypeTests {

    @Test("JSON decoding of flatrate", .tags(.decoding))
    func decodeFlatrate() throws {
        let data = Data(#""flatrate""#.utf8)

        let result = try JSONDecoder().decode(
            WatchMonetizationType.self, from: data
        )

        #expect(result == .flatrate)
    }

    @Test("JSON decoding of free", .tags(.decoding))
    func decodeFree() throws {
        let data = Data(#""free""#.utf8)

        let result = try JSONDecoder().decode(
            WatchMonetizationType.self, from: data
        )

        #expect(result == .free)
    }

    @Test("JSON decoding of ads", .tags(.decoding))
    func decodeAds() throws {
        let data = Data(#""ads""#.utf8)

        let result = try JSONDecoder().decode(
            WatchMonetizationType.self, from: data
        )

        #expect(result == .ads)
    }

    @Test("JSON decoding of rent", .tags(.decoding))
    func decodeRent() throws {
        let data = Data(#""rent""#.utf8)

        let result = try JSONDecoder().decode(
            WatchMonetizationType.self, from: data
        )

        #expect(result == .rent)
    }

    @Test("JSON decoding of buy", .tags(.decoding))
    func decodeBuy() throws {
        let data = Data(#""buy""#.utf8)

        let result = try JSONDecoder().decode(
            WatchMonetizationType.self, from: data
        )

        #expect(result == .buy)
    }

    @Test("JSON encoding of flatrate", .tags(.encoding))
    func encodeFlatrate() throws {
        let data = try JSONEncoder().encode(
            WatchMonetizationType.flatrate
        )
        let result = String(data: data, encoding: .utf8)

        #expect(result == #""flatrate""#)
    }

    @Test("JSON encoding of free", .tags(.encoding))
    func encodeFree() throws {
        let data = try JSONEncoder().encode(
            WatchMonetizationType.free
        )
        let result = String(data: data, encoding: .utf8)

        #expect(result == #""free""#)
    }

    @Test("JSON encoding of ads", .tags(.encoding))
    func encodeAds() throws {
        let data = try JSONEncoder().encode(
            WatchMonetizationType.ads
        )
        let result = String(data: data, encoding: .utf8)

        #expect(result == #""ads""#)
    }

    @Test("JSON encoding of rent", .tags(.encoding))
    func encodeRent() throws {
        let data = try JSONEncoder().encode(
            WatchMonetizationType.rent
        )
        let result = String(data: data, encoding: .utf8)

        #expect(result == #""rent""#)
    }

    @Test("JSON encoding of buy", .tags(.encoding))
    func encodeBuy() throws {
        let data = try JSONEncoder().encode(
            WatchMonetizationType.buy
        )
        let result = String(data: data, encoding: .utf8)

        #expect(result == #""buy""#)
    }

}
