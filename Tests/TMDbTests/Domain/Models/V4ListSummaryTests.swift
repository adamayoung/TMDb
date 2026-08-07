//
//  V4ListSummaryTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models, .decoding))
struct V4ListSummaryTests {

    private func decodeFixture() throws -> V4ListSummary {
        let page = try JSONDecoder.theMovieDatabaseV4.decode(
            PageableListResult<V4ListSummary>.self, fromResource: "v4-account-lists"
        )

        return try #require(page.results.first)
    }

    @Test("decodes an account list summary")
    func decodesSummary() throws {
        let result = try decodeFixture()

        #expect(result.id == 8_678_999)
        #expect(result.name == "My Watchlist")
        #expect(result.accountObjectID == "1a2b3c4d5e6f7a8b9c0d1e2f")
        #expect(result.numberOfItems == 2)
        #expect(result.languageCode == "en")
        #expect(result.countryCode == "US")
    }

    @Test("maps the integer public flag to a Bool")
    func mapsIntegerPublicFlag() throws {
        // This endpoint sends 0/1 where the list-details endpoint sends a bool.
        let result = try decodeFixture()

        #expect(result.isPublic)
        #expect(result.isAdult == false)
        #expect(result.isFeatured == false)
    }

    @Test("maps the string runtime to an Int")
    func mapsStringRuntime() throws {
        let result = try decodeFixture()

        #expect(result.runtime == 0)
    }

    @Test("exposes the integer sort order exactly as sent")
    func exposesRawSortBy() throws {
        // TMDb reports sort order as an Int here and a String on list details,
        // with no published mapping — so it is not decoded into a shared type.
        let result = try decodeFixture()

        #expect(result.sortBy == 1)
    }

    @Test("decodes the UTC timestamp form used by this endpoint")
    func decodesTimestamps() throws {
        let result = try decodeFixture()

        #expect(result.updatedAt > result.createdAt)
    }

    @Test("round trips, preserving the wire types")
    func roundTrips() throws {
        // The raw values are stored as sent, so encoding must re-emit `public`
        // as an integer and `runtime` as a string — not as a Bool and an Int.
        let original = try decodeFixture()

        let encoded = try JSONEncoder.theMovieDatabaseV4.encode(original)
        let json = try #require(
            JSONSerialization.jsonObject(with: encoded) as? [String: Any]
        )

        #expect(json["public"] as? Int == 1)
        #expect(json["runtime"] as? String == "0")

        let result = try JSONDecoder.theMovieDatabaseV4.decode(
            V4ListSummary.self, from: encoded
        )
        #expect(result == original)
    }

}
