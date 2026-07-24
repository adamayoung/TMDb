//
//  SamplesTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
import TMDbIntelligence
import TMDbIntelligenceTesting

@Suite(.tags(.testingSupport, .samples))
struct SamplesTests {

    @Test("SearchPlan.sample is non-degenerate")
    func searchPlanSampleIsNonDegenerate() throws {
        let plan = SearchPlan.sample

        let title = try #require(plan.title)
        #expect(!title.isEmpty)
        #expect(plan.isInScope)
    }

}
