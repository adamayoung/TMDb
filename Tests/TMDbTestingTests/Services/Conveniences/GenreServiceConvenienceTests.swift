//
//  GenreServiceConvenienceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
import TMDb
import TMDbTesting

///
/// Pins the zero-defaulted-argument conveniences on ``GenreService``.
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
@Suite(.tags(.testingSupport, .mocks, .genre))
struct GenreServiceConvenienceTests {

    var service: MockGenreService

    init() {
        self.service = MockGenreService()
    }

    @Test("movieGenres() forwards a nil language to the requirement")
    func movieGenresForwardsNilLanguage() async throws {
        _ = try await service.movieGenres()

        #expect(service.movieGenresCalls.count == 1)
        let call = try #require(service.movieGenresCalls.first)
        #expect(call.language == nil)
    }

    @Test("tvSeriesGenres() forwards a nil language to the requirement")
    func tvSeriesGenresForwardsNilLanguage() async throws {
        _ = try await service.tvSeriesGenres()

        #expect(service.tvSeriesGenresCalls.count == 1)
        let call = try #require(service.tvSeriesGenresCalls.first)
        #expect(call.language == nil)
    }

}
