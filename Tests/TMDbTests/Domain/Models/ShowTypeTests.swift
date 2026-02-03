//
//  ShowTypeTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct ShowTypeTests {

    @Test("Movie show type rawValue is movie")
    func movieShowTypeRawValue() {
        #expect(ShowType.movie.rawValue == "movie")
    }

    @Test("TV series show type rawValue is tv")
    func tvSeriesShowTypeRawValue() {
        #expect(ShowType.tvSeries.rawValue == "tv")
    }

}
