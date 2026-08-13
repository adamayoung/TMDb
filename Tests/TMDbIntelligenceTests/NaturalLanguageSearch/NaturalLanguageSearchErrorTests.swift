//
//  NaturalLanguageSearchErrorTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb
@testable import TMDbIntelligence

@Suite("NaturalLanguageSearchError")
struct NaturalLanguageSearchErrorTests {

    private struct Underlying: Error {}

    /// 13. two `.searchFailed` carrying the same `TMDbError` are equal
    @Test("two searchFailed carrying the same TMDbError are equal")
    func searchFailedEqualityIsStructural() {
        // `==` is hand-written and ends in `default: false`, so a missing arm
        // compiles silently and makes a value unequal to itself — while every
        // `#expect(throws:)` using it still *reports* the correct error.
        #expect(
            NaturalLanguageSearchError.searchFailed(.tooManyRequests())
                == NaturalLanguageSearchError.searchFailed(.tooManyRequests())
        )
        #expect(
            NaturalLanguageSearchError.searchFailed(.cancelled)
                == NaturalLanguageSearchError.searchFailed(.cancelled)
        )
    }

    /// 14. `.searchFailed` discriminates by the wrapped error
    @Test("searchFailed discriminates by the wrapped TMDbError")
    func searchFailedDiscriminatesByWrappedError() {
        #expect(
            NaturalLanguageSearchError.searchFailed(.tooManyRequests())
                != NaturalLanguageSearchError.searchFailed(.network(Underlying()))
        )
        #expect(
            NaturalLanguageSearchError.searchFailed(.tooManyRequests())
                != NaturalLanguageSearchError.searchFailed(.notFound())
        )
    }

    /// 15. `.searchFailed` is distinct from the planning and cancellation cases
    @Test("searchFailed is distinct from planningFailed and cancelled")
    func searchFailedIsDistinctFromOtherCases() {
        let searchFailed = NaturalLanguageSearchError.searchFailed(.tooManyRequests())

        #expect(searchFailed != .planningFailed(underlying: nil))
        #expect(searchFailed != .planningFailed(underlying: Underlying()))
        #expect(searchFailed != .cancelled)
        #expect(searchFailed != .rateLimited)
    }

    /// 16. `.searchFailed`'s description is the wrapped error's
    @Test("searchFailed reports the wrapped TMDbError's description")
    func searchFailedDescriptionDelegates() {
        let underlying = TMDbError.tooManyRequests()
        let error = NaturalLanguageSearchError.searchFailed(underlying)

        #expect(error.errorDescription == underlying.errorDescription)
        // The bug this change fixes: a TMDb failure claiming the prompt was
        // uninterpretable.
        #expect(error.errorDescription != "The request could not be interpreted.")
    }

    /// 17. `.rateLimited` still describes the on-device model, not TMDb
    @Test("rateLimited still names the on-device model")
    func rateLimitedStillNamesTheOnDeviceModel() throws {
        let description = try #require(NaturalLanguageSearchError.rateLimited.errorDescription)

        #expect(description.contains("on-device model"))
    }

}
