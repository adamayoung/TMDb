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
        // A non-zero value on purpose: against `"runtime": "0"` a successful
        // parse and the `?? 0` fallback are indistinguishable, so the test
        // would still pass with the conversion deleted.
        let result = try decodeFixture()

        #expect(result.runtime == 8433)
    }

    @Test("a non-numeric runtime falls back to zero rather than throwing")
    func nonNumericRuntimeFallsBack() throws {
        let json = Data(#"""
        {"id": 1, "name": "List", "runtime": "not-a-number", "public": 1,
         "iso_639_1": "en", "iso_3166_1": "US", "account_object_id": "abc",
         "number_of_items": 0, "created_at": "2026-08-06 23:26:00 UTC",
         "updated_at": "2026-08-06 23:26:00 UTC"}
        """#.utf8)

        let result = try JSONDecoder.theMovieDatabaseV4.decode(V4ListSummary.self, from: json)

        #expect(result.runtime == 0)
    }

    @Test("a summary missing optional fields still decodes rather than vanishing")
    func minimalSummaryDecodes() throws {
        // A page no longer swallows an element that throws, so a throw here would
        // now fail the caller's whole `lists(forAccount:)` call. Keeping the
        // summary tolerant reserves that loud failure for a real decoder defect.
        let json = Data(#"{"id": 42, "name": "Sparse"}"#.utf8)

        let result = try JSONDecoder.theMovieDatabaseV4.decode(V4ListSummary.self, from: json)

        #expect(result.id == 42)
        #expect(result.name == "Sparse")
        #expect(result.isPublic == false)
        #expect(result.runtime == 0)
        #expect(result.numberOfItems == 0)
        #expect(result.accountObjectID == "")
    }

    @Test("a sparse summary survives inside a page instead of being dropped")
    func sparseSummarySurvivesInAPage() throws {
        let json = Data(#"""
        {"page": 1, "total_pages": 1, "total_results": 2,
         "results": [{"id": 1, "name": "Full", "public": 1, "runtime": "10"},
                     {"id": 2, "name": "Sparse"}]}
        """#.utf8)

        let page = try JSONDecoder.theMovieDatabaseV4.decode(
            PageableListResult<V4ListSummary>.self, from: json
        )

        #expect(page.results.count == 2)
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
        #expect(json["runtime"] as? String == "8433")

        let result = try JSONDecoder.theMovieDatabaseV4.decode(
            V4ListSummary.self, from: encoded
        )
        #expect(result == original)
    }

}
