//
//  SearchDegradationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDbIntelligence

@Suite("SearchDegradation")
struct SearchDegradationTests {

    /// 11. `.other` compares by its identifier
    @Test("other compares by its identifier")
    func otherComparesByIdentifier() {
        #expect(SearchDegradation.other("unresolvedNetwork") == .other("unresolvedNetwork"))
        #expect(SearchDegradation.other("unresolvedNetwork") != .other("unresolvedLanguage"))
    }

    /// 12. `.other` is distinct from the modelled degradations
    @Test("other is distinct from the modelled degradations")
    func otherIsDistinctFromModelledDegradations() {
        let other = SearchDegradation.other("unresolvedNetwork")

        #expect(other != .underspecified)
        #expect(other != .relaxedConstraints)
        #expect(other != .unresolvedGenre("unresolvedNetwork"))
    }

}
