//
//  TVSeriesAggregateCreditsTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.models))
struct TVSeriesAggregateCreditsTests {

    @Test("JSON decoding of TVSeriesAggregateCredits", .tags(.decoding))
    func decodeReturnsTVSeriesAggregateCredits() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            TVSeriesAggregateCredits.self,
            fromResource: "tv-series-aggregate-credits"
        )

        #expect(result.id == 4604)
        #expect(result.cast.count == 4)
        #expect(result.crew.count == 2)
    }

}
