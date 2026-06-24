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

    @Test("withKeywords sets keywords and defaults to AND join")
    func withKeywordsSetsKeywordsAndDefaultsToAndJoin() {
        let filter = DiscoverTVSeriesFilter().withKeywords([10, 20])

        #expect(filter.keywords == [10, 20])
        #expect(filter.keywordsJoin == .and)
    }

    @Test("withKeywords sets keywords and join operator")
    func withKeywordsSetsKeywordsAndJoinOperator() {
        let filter = DiscoverTVSeriesFilter()
            .withKeywords([10, 20], joinedBy: .or)

        #expect(filter.keywords == [10, 20])
        #expect(filter.keywordsJoin == .or)
    }

    @Test("withoutGenres sets without genres")
    func withoutGenresSetsWithoutGenres() {
        let filter = DiscoverTVSeriesFilter().withoutGenres([27, 53])

        #expect(filter.withoutGenres == [27, 53])
    }

    @Test("withoutKeywords sets without keywords")
    func withoutKeywordsSetsWithoutKeywords() {
        let filter = DiscoverTVSeriesFilter().withoutKeywords([11, 12])

        #expect(filter.withoutKeywords == [11, 12])
    }

    @Test("withNetworks sets networks")
    func withNetworksSetsNetworks() {
        let filter = DiscoverTVSeriesFilter().withNetworks([213, 49])

        #expect(filter.networks == [213, 49])
    }

    @Test("withCompanies sets companies")
    func withCompaniesSetsCompanies() {
        let filter = DiscoverTVSeriesFilter().withCompanies([5, 6, 7])

        #expect(filter.companies == [5, 6, 7])
    }

    @Test("originalLanguage sets original language")
    func originalLanguageSetsOriginalLanguage() {
        let filter = DiscoverTVSeriesFilter().originalLanguage("en")

        #expect(filter.originalLanguage == "en")
    }

    @Test("includeAdult sets include adult")
    func includeAdultSetsIncludeAdult() {
        let filter = DiscoverTVSeriesFilter().includeAdult(true)

        #expect(filter.includeAdult == true)
    }

    @Test("watchProviders sets providers and region")
    func watchProvidersSetsProvidersAndRegion() {
        let filter = DiscoverTVSeriesFilter()
            .watchProviders([8, 9], region: "US")

        #expect(filter.watchProviders == [8, 9])
        #expect(filter.watchRegion == "US")
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
    ) -> DiscoverTVSeriesFilter {
        DiscoverTVSeriesFilter(
            originalLanguage: "en",
            genres: [18],
            withoutGenres: [27],
            firstAirDateYear: 2024,
            firstAirDateMin: Date(timeIntervalSince1970: 1_000_000),
            firstAirDateMax: Date(timeIntervalSince1970: 2_000_000),
            airDateMin: Date(timeIntervalSince1970: 3_000_000),
            airDateMax: Date(timeIntervalSince1970: 4_000_000),
            voteAverageMin: 7.0,
            voteAverageMax: 9.0,
            voteCountMin: 100,
            voteCountMax: 1000,
            networks: [213],
            companies: [5],
            keywords: [10],
            withoutKeywords: [11],
            runtimeMin: 30,
            runtimeMax: 60,
            includeAdult: includeAdult,
            watchProviders: [8],
            watchRegion: "US",
            withOriginCountry: "GB",
            withStatus: [.returning],
            withType: [.scripted],
            withoutCompanies: [6],
            watchMonetizationTypes: [.flatrate],
            screenedTheatrically: true,
            withPeople: [2],
            withoutWatchProviders: [9],
            includeNullFirstAirDates: true,
            genresJoin: .or,
            keywordsJoin: .or
        )
    }

}
