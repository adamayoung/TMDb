//
//  TrendingTimeWindowFilterTypeTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.trending))
struct TrendingTimeWindowFilterTypeTests {

    @Test("day raw value is \"day\"")
    func dayRawValue() {
        let filterType = TrendingTimeWindowFilterType.day

        #expect(filterType.rawValue == "day")
    }

    func weekRawValue() {
        let filterType = TrendingTimeWindowFilterType.week

        #expect(filterType.rawValue == "week")
    }

}
