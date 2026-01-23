//
//  TVSeasonAggregateCreditsTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.models))
struct TVSeasonAggregateCreditsTests {

    @Test("JSON decoding of TVSeasonAggregateCredits", .tags(.decoding))
    func decodeReturnsTVSeasonAggregateCredits() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            TVSeriesAggregateCredits.self,
            fromResource: "tv-season-aggregate-credits"
        )

        #expect(result.id == 3625)
        #expect(result.cast.count == 3)
        #expect(result.crew.count == 2)
    }

}
