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

    @Test("withKeywords sets keywords and defaults to AND join")
    func withKeywordsSetsKeywordsAndDefaultsToAndJoin() {
        let filter = DiscoverMovieFilter().withKeywords([10, 20])

        #expect(filter.keywords == [10, 20])
        #expect(filter.keywordsJoin == .and)
    }

    @Test("withKeywords sets keywords and join operator")
    func withKeywordsSetsKeywordsAndJoinOperator() {
        let filter = DiscoverMovieFilter().withKeywords([10, 20], joinedBy: .or)

        #expect(filter.keywords == [10, 20])
        #expect(filter.keywordsJoin == .or)
    }

    @Test("withCompanies sets companies")
    func withCompaniesSetsCompanies() {
        let filter = DiscoverMovieFilter().withCompanies([5, 6, 7])

        #expect(filter.companies == [5, 6, 7])
    }

    @Test("originalLanguage sets original language")
    func originalLanguageSetsOriginalLanguage() {
        let filter = DiscoverMovieFilter().originalLanguage("en")

        #expect(filter.originalLanguage == "en")
    }

    @Test("includeVideo sets include video")
    func includeVideoSetsIncludeVideo() {
        let filter = DiscoverMovieFilter().includeVideo(true)

        #expect(filter.includeVideo == true)
    }

    @Test("watchProviders sets providers and region")
    func watchProvidersSetsProvidersAndRegion() {
        let filter = DiscoverMovieFilter()
            .watchProviders([8, 9], region: "US")

        #expect(filter.watchProviders == [8, 9])
        #expect(filter.watchRegion == "US")
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

    @Test("no-op mutation preserves every other populated field")
    func noOpMutationPreservesEveryOtherPopulatedField() {
        // A single no-op-style mutation: re-applying includeAdult must leave
        // every other field untouched. This guards the ~31-parameter `copy`
        // helper against a future field being silently dropped to nil.
        let base = Self.fullyPopulatedFilter(includeAdult: false)
        let mutated = base.includeAdult(true)
        let expected = Self.fullyPopulatedFilter(includeAdult: true)

        #expect(mutated == expected)
    }

    private static func fullyPopulatedFilter(
        includeAdult: Bool
    ) -> DiscoverMovieFilter {
        DiscoverMovieFilter(
            people: [1],
            originalLanguage: "en",
            genres: [28],
            withoutGenres: [27],
            primaryReleaseYear: .on(2024),
            voteAverageMin: 7.0,
            voteAverageMax: 9.0,
            voteCountMin: 100,
            voteCountMax: 1000,
            companies: [5],
            keywords: [10],
            withoutKeywords: [11],
            runtimeMin: 90,
            runtimeMax: 180,
            includeAdult: includeAdult,
            includeVideo: true,
            watchProviders: [8],
            watchRegion: "US",
            certification: "PG-13",
            certificationMin: "G",
            certificationMax: "R",
            certificationCountry: "US",
            releaseTypes: [.theatrical],
            withCast: [2],
            withCrew: [3],
            withOriginCountry: "GB",
            withoutCompanies: [6],
            watchMonetizationTypes: [.flatrate],
            genresJoin: .or,
            keywordsJoin: .or
        )
    }

}
