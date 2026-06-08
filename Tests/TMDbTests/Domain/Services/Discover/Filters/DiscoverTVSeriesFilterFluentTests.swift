//
//  DiscoverTVSeriesFilterFluentTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.filters, .discover))
struct DiscoverTVSeriesFilterFluentTests {

    @Test("withGenres sets genres and defaults to AND join")
    func withGenresSetsGenresAndDefaultsToAndJoin() {
        let filter = DiscoverTVSeriesFilter().withGenres([18, 10765])

        #expect(filter.genres == [18, 10765])
        #expect(filter.genresJoin == .and)
    }

    @Test("withGenres with explicit OR join sets join operator")
    func withGenresWithExplicitOrJoinSetsJoinOperator() {
        let filter = DiscoverTVSeriesFilter()
            .withGenres([18, 10765], joinedBy: .or)

        #expect(filter.genres == [18, 10765])
        #expect(filter.genresJoin == .or)
    }

    @Test("withKeywords sets keywords and join operator")
    func withKeywordsSetsKeywordsAndJoinOperator() {
        let filter = DiscoverTVSeriesFilter()
            .withKeywords([10, 20], joinedBy: .or)

        #expect(filter.keywords == [10, 20])
        #expect(filter.keywordsJoin == .or)
    }

    @Test("firstAirDateYear sets first air date year")
    func firstAirDateYearSetsFirstAirDateYear() {
        let filter = DiscoverTVSeriesFilter().firstAirDateYear(2024)

        #expect(filter.firstAirDateYear == 2024)
    }

    @Test("voteAverage with closed range maps to min and max")
    func voteAverageWithClosedRangeMapsToMinAndMax() {
        let filter = DiscoverTVSeriesFilter().voteAverage(in: 7.0 ... 10.0)

        #expect(filter.voteAverageMin == 7.0)
        #expect(filter.voteAverageMax == 10.0)
    }

    @Test("voteCount with closed range maps to min and max")
    func voteCountWithClosedRangeMapsToMinAndMax() {
        let filter = DiscoverTVSeriesFilter().voteCount(in: 100 ... 1000)

        #expect(filter.voteCountMin == 100)
        #expect(filter.voteCountMax == 1000)
    }

    @Test("runtime with closed range maps to min and max")
    func runtimeWithClosedRangeMapsToMinAndMax() {
        let filter = DiscoverTVSeriesFilter().runtime(in: 30 ... 60)

        #expect(filter.runtimeMin == 30)
        #expect(filter.runtimeMax == 60)
    }

    @Test("chaining composes multiple fields without mutating the base")
    func chainingComposesMultipleFieldsWithoutMutatingTheBase() {
        let base = DiscoverTVSeriesFilter()

        let filter = base
            .withGenres([18])
            .voteAverage(in: 8.0 ... 10.0)
            .firstAirDateYear(2024)

        #expect(filter.genres == [18])
        #expect(filter.voteAverageMin == 8.0)
        #expect(filter.firstAirDateYear == 2024)

        #expect(base.genres == nil)
        #expect(base.voteAverageMin == nil)
        #expect(base.firstAirDateYear == nil)
    }

    @Test("filters are equatable")
    func filtersAreEquatable() {
        let lhs = DiscoverTVSeriesFilter().withGenres([18])
        let rhs = DiscoverTVSeriesFilter().withGenres([18])

        #expect(lhs == rhs)
    }

}
