//
//  NaturalLanguageSearchAvailabilityTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDbIntelligence

@Suite("NaturalLanguageSearchAvailability")
struct NaturalLanguageSearchAvailabilityTests {

    /// 7. every unavailability reason has a distinct, stable description
    @Test("every unavailability reason has a distinct, stable description")
    func everyReasonHasADistinctStableDescription() {
        let expected: [(NaturalLanguageSearchAvailability.Reason, String)] = [
            (.deviceNotEligible, "deviceNotEligible"),
            (.notEnabled, "notEnabled"),
            (.modelNotReady, "modelNotReady"),
            (.unsupportedOS, "unsupportedOS"),
            (.unknown, "unknown")
        ]

        for (reason, description) in expected {
            #expect(reason.description == description)
            #expect(description == "\(reason)")
        }

        #expect(Set(expected.map(\.1)).count == expected.count)
    }

    /// 8. an unavailable availability equals itself and differs by reason
    @Test("an unavailable availability equals itself and differs by reason")
    func unavailableEqualityDiscriminatesByReason() {
        #expect(
            NaturalLanguageSearchAvailability.unavailable(.modelNotReady)
                == NaturalLanguageSearchAvailability.unavailable(.modelNotReady)
        )
        #expect(
            NaturalLanguageSearchAvailability.unavailable(.modelNotReady)
                != NaturalLanguageSearchAvailability.unavailable(.notEnabled)
        )
    }

    /// 9. an unavailable availability never equals `.available`
    @Test("an unavailable availability never equals available")
    func unavailableNeverEqualsAvailable() {
        // Guards the outer enum's synthesized `==` now that its payload is a
        // struct rather than an enum.
        #expect(NaturalLanguageSearchAvailability.unavailable(.modelNotReady) != .available)
        #expect(NaturalLanguageSearchAvailability.unavailable(.unknown) != .available)
    }

    /// 10. `if case .unavailable(let reason)` binds the reason
    @Test("pattern matching binds the unavailability reason")
    func patternMatchingBindsTheReason() {
        let availability = NaturalLanguageSearchAvailability.unavailable(.deviceNotEligible)

        guard case .unavailable(let reason) = availability else {
            Issue.record("expected an unavailable availability")
            return
        }

        #expect(reason == .deviceNotEligible)
        #expect(reason != .notEnabled)
    }

    /// 7b. a reason works as a dictionary key and a Set member
    @Test("a reason works as a dictionary key and a Set member")
    func reasonIsUsableAsAKeyAndSetMember() {
        // A payload-free enum is implicitly Hashable; the struct must keep that.
        let counts: [NaturalLanguageSearchAvailability.Reason: Int] = [
            .modelNotReady: 1,
            .notEnabled: 2
        ]

        #expect(counts[.modelNotReady] == 1)
        #expect(counts[.notEnabled] == 2)
        #expect(counts[.unknown] == nil)

        let reasons: Set<NaturalLanguageSearchAvailability.Reason> = [
            .modelNotReady, .modelNotReady, .notEnabled
        ]
        #expect(reasons.count == 2)
    }

}
