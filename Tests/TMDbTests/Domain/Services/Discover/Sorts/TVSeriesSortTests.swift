//
//  TVSeriesSortTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.discover))
struct TVSeriesSortTests {

    @Test("popularity ascending description is popularity.asc")
    func popularityAscendingReturnsRawValue() {
        let sort = TVSeriesSort.popularity(descending: false)

        #expect(sort.description == "popularity.asc")
    }

    @Test("popularity descending description is popularity.desc")
    func popularityDescendingReturnsRawValue() {
        let sort = TVSeriesSort.popularity(descending: true)

        #expect(sort.description == "popularity.desc")
    }

    @Test("firstAirDate ascending description is first_air_date.asc")
    func firstAirDateAscendingReturnsRawValue() {
        let sort = TVSeriesSort.firstAirDate(descending: false)

        #expect(sort.description == "first_air_date.asc")
    }

    @Test("firstAirDate descending description is first_air_date.desc")
    func firstAirDateDescendingReturnsRawValue() {
        let sort = TVSeriesSort.firstAirDate(descending: true)

        #expect(sort.description == "first_air_date.desc")
    }

    @Test("voteAverage ascending description is vote_average.asc")
    func voteAverageAscendingReturnsRawValue() {
        let sort = TVSeriesSort.voteAverage(descending: false)

        #expect(sort.description == "vote_average.asc")
    }

    @Test("voteAverage descending description is vote_average.desc")
    func voteAverageDescendingReturnsRawValue() {
        let sort = TVSeriesSort.voteAverage(descending: true)

        #expect(sort.description == "vote_average.desc")
    }

}
