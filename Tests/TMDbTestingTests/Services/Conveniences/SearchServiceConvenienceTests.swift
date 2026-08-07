//
//  SearchServiceConvenienceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
import TMDb
import TMDbTesting

///
/// Pins the zero-defaulted-argument conveniences on ``SearchService``.
///
/// Each convenience drops a parameter rather than defaulting it, so that its
/// signature cannot witness the requirement it forwards to. These tests assert
/// the other half of that contract: the convenience still reaches the
/// requirement, passing `nil` for the parameter it omits.
///
/// They live in this target on purpose. `TMDbTesting`'s mocks implement the
/// *requirements* and never the conveniences, and this target imports through
/// the public API with no `@testable` — so the conformance exercised here is
/// exactly the one a third-party conformer has, which is the only population
/// the hazard can reach.
///
@Suite(.tags(.testingSupport, .mocks, .search))
struct SearchServiceConvenienceTests {

    var service: MockSearchService

    init() {
        self.service = MockSearchService()
    }

    @Test("searchCompanies(query:) forwards a nil page to the requirement")
    func searchCompaniesForwardsNilPage() async throws {
        _ = try await service.searchCompanies(query: "pixar")

        #expect(service.searchCompaniesCalls.count == 1)
        let call = try #require(service.searchCompaniesCalls.first)
        #expect(call.page == nil)
        #expect(call.query == "pixar")
    }

    @Test("searchKeywords(query:) forwards a nil page to the requirement")
    func searchKeywordsForwardsNilPage() async throws {
        _ = try await service.searchKeywords(query: "space")

        #expect(service.searchKeywordsCalls.count == 1)
        let call = try #require(service.searchKeywordsCalls.first)
        #expect(call.page == nil)
        #expect(call.query == "space")
    }

}
