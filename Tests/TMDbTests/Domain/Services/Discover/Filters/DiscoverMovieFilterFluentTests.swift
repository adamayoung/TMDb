//
//  DiscoverMovieFilterFluentTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.filters, .discover))
struct DiscoverMovieFilterFluentTests {

    @Test("withGenres sets genres and defaults to AND join")
    func withGenresSetsGenresAndDefaultsToAndJoin() {
        let filter = DiscoverMovieFilter().withGenres([28, 12])

        #expect(filter.genres == [28, 12])
        #expect(filter.genresJoin == .and)
    }

    @Test("withGenres with explicit OR join sets join operator")
    func withGenresWithExplicitOrJoinSetsJoinOperator() {
        let filter = DiscoverMovieFilter().withGenres([28, 12], joinedBy: .or)

        #expect(filter.genres == [28, 12])
        #expect(filter.genresJoin == .or)
    }

    @Test("withoutGenres sets without genres")
    func withoutGenresSetsWithoutGenres() {
        let filter = DiscoverMovieFilter().withoutGenres([27, 53])

        #expect(filter.withoutGenres == [27, 53])
    }

    @Test("withKeywords sets keywords and join operator")
    func withKeywordsSetsKeywordsAndJoinOperator() {
        let filter = DiscoverMovieFilter().withKeywords([10, 20], joinedBy: .or)

        #expect(filter.keywords == [10, 20])
        #expect(filter.keywordsJoin == .or)
    }

    @Test("withPeople sets people")
    func withPeopleSetsPeople() {
        let filter = DiscoverMovieFilter().withPeople([1, 2, 3])

        #expect(filter.people == [1, 2, 3])
    }

    @Test("primaryReleaseYear sets release year filter")
    func primaryReleaseYearSetsReleaseYearFilter() {
        let filter = DiscoverMovieFilter().primaryReleaseYear(.on(2024))

        #expect(filter.primaryReleaseYear == .on(2024))
    }

    @Test("voteAverage with closed range maps to min and max")
    func voteAverageWithClosedRangeMapsToMinAndMax() {
        let filter = DiscoverMovieFilter().voteAverage(in: 7.0 ... 10.0)

        #expect(filter.voteAverageMin == 7.0)
        #expect(filter.voteAverageMax == 10.0)
    }

    @Test("voteCount with closed range maps to min and max")
    func voteCountWithClosedRangeMapsToMinAndMax() {
        let filter = DiscoverMovieFilter().voteCount(in: 100 ... 1000)

        #expect(filter.voteCountMin == 100)
        #expect(filter.voteCountMax == 1000)
    }

    @Test("runtime with closed range maps to min and max")
    func runtimeWithClosedRangeMapsToMinAndMax() {
        let filter = DiscoverMovieFilter().runtime(in: 90 ... 180)

        #expect(filter.runtimeMin == 90)
        #expect(filter.runtimeMax == 180)
    }

    @Test("includeAdult sets include adult")
    func includeAdultSetsIncludeAdult() {
        let filter = DiscoverMovieFilter().includeAdult(true)

        #expect(filter.includeAdult == true)
    }

    @Test("chaining composes multiple fields without mutating the base")
    func chainingComposesMultipleFieldsWithoutMutatingTheBase() {
        let base = DiscoverMovieFilter()

        let filter = base
            .withGenres([28, 12])
            .voteAverage(in: 7.0 ... 10.0)
            .primaryReleaseYear(.on(2024))

        #expect(filter.genres == [28, 12])
        #expect(filter.voteAverageMin == 7.0)
        #expect(filter.voteAverageMax == 10.0)
        #expect(filter.primaryReleaseYear == .on(2024))

        // Base instance is unchanged (value semantics preserved).
        #expect(base.genres == nil)
        #expect(base.voteAverageMin == nil)
        #expect(base.primaryReleaseYear == nil)
    }

    @Test("filters are equatable")
    func filtersAreEquatable() {
        let lhs = DiscoverMovieFilter().withGenres([28, 12])
        let rhs = DiscoverMovieFilter().withGenres([28, 12])

        #expect(lhs == rhs)
    }

}
