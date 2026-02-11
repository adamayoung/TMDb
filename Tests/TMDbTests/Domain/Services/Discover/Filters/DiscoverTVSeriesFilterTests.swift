//
//  DiscoverTVSeriesFilterTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.filters, .discover))
struct DiscoverTVSeriesFilterTests {

    @Test("init with default values creates filter with nil properties")
    func initWithDefaultValuesCreatesFilterWithNilProperties() {
        let filter = DiscoverTVSeriesFilter()

        #expect(filter.originalLanguage == nil)
        #expect(filter.genres == nil)
        #expect(filter.withoutGenres == nil)
        #expect(filter.firstAirDateYear == nil)
        #expect(filter.firstAirDateMin == nil)
        #expect(filter.firstAirDateMax == nil)
        #expect(filter.airDateMin == nil)
        #expect(filter.airDateMax == nil)
        #expect(filter.voteAverageMin == nil)
        #expect(filter.voteAverageMax == nil)
        #expect(filter.voteCountMin == nil)
        #expect(filter.voteCountMax == nil)
        #expect(filter.networks == nil)
        #expect(filter.companies == nil)
        #expect(filter.keywords == nil)
        #expect(filter.withoutKeywords == nil)
        #expect(filter.runtimeMin == nil)
        #expect(filter.runtimeMax == nil)
        #expect(filter.includeAdult == nil)
        #expect(filter.watchProviders == nil)
        #expect(filter.watchRegion == nil)
    }

    @Test("init with original language sets original language property")
    func initWithOriginalLanguageSetsOriginalLanguageProperty() {
        let filter = DiscoverTVSeriesFilter(originalLanguage: "en")

        #expect(filter.originalLanguage == "en")
    }

    @Test("init with genres sets genres property")
    func initWithGenresSetsGenresProperty() {
        let genres = [18, 35, 80]

        let filter = DiscoverTVSeriesFilter(genres: genres)

        #expect(filter.genres == genres)
    }

    @Test("init with without genres sets without genres property")
    func initWithWithoutGenresSetsWithoutGenresProperty() {
        let withoutGenres = [27, 53]

        let filter = DiscoverTVSeriesFilter(withoutGenres: withoutGenres)

        #expect(filter.withoutGenres == withoutGenres)
    }

    @Test("init with first air date year sets property")
    func initWithFirstAirDateYearSetsProperty() {
        let filter = DiscoverTVSeriesFilter(firstAirDateYear: 2024)

        #expect(filter.firstAirDateYear == 2024)
    }

    @Test("init with first air date range sets properties")
    func initWithFirstAirDateRangeSetsProperties() {
        let min = Date(iso8601: "2024-01-01T00:00:00Z")
        let max = Date(iso8601: "2024-12-31T00:00:00Z")

        let filter = DiscoverTVSeriesFilter(
            firstAirDateMin: min,
            firstAirDateMax: max
        )

        #expect(filter.firstAirDateMin == min)
        #expect(filter.firstAirDateMax == max)
    }

    @Test("init with air date range sets properties")
    func initWithAirDateRangeSetsProperties() {
        let min = Date(iso8601: "2024-01-01T00:00:00Z")
        let max = Date(iso8601: "2024-12-31T00:00:00Z")

        let filter = DiscoverTVSeriesFilter(
            airDateMin: min,
            airDateMax: max
        )

        #expect(filter.airDateMin == min)
        #expect(filter.airDateMax == max)
    }

    @Test("init with vote average range sets properties")
    func initWithVoteAverageRangeSetsProperties() {
        let filter = DiscoverTVSeriesFilter(
            voteAverageMin: 7.0,
            voteAverageMax: 10.0
        )

        #expect(filter.voteAverageMin == 7.0)
        #expect(filter.voteAverageMax == 10.0)
    }

    @Test("init with vote count range sets properties")
    func initWithVoteCountRangeSetsProperties() {
        let filter = DiscoverTVSeriesFilter(
            voteCountMin: 100,
            voteCountMax: 1000
        )

        #expect(filter.voteCountMin == 100)
        #expect(filter.voteCountMax == 1000)
    }

    @Test("init with networks sets networks property")
    func initWithNetworksSetsNetworksProperty() {
        let networks = [213, 1024]

        let filter = DiscoverTVSeriesFilter(networks: networks)

        #expect(filter.networks == networks)
    }

    @Test("init with companies sets companies property")
    func initWithCompaniesSetesCompaniesProperty() {
        let companies = [1, 2]

        let filter = DiscoverTVSeriesFilter(companies: companies)

        #expect(filter.companies == companies)
    }

    @Test("init with keywords sets keywords property")
    func initWithKeywordsSetsKeywordsProperty() {
        let keywords = [10, 20]

        let filter = DiscoverTVSeriesFilter(keywords: keywords)

        #expect(filter.keywords == keywords)
    }

    @Test("init with without keywords sets without keywords property")
    func initWithWithoutKeywordsSetsWithoutKeywordsProperty() {
        let withoutKeywords = [30, 40]

        let filter = DiscoverTVSeriesFilter(
            withoutKeywords: withoutKeywords
        )

        #expect(filter.withoutKeywords == withoutKeywords)
    }

    @Test("init with runtime range sets runtime properties")
    func initWithRuntimeRangeSetsRuntimeProperties() {
        let filter = DiscoverTVSeriesFilter(runtimeMin: 30, runtimeMax: 60)

        #expect(filter.runtimeMin == 30)
        #expect(filter.runtimeMax == 60)
    }

    @Test("init with include adult sets include adult property")
    func initWithIncludeAdultSetsIncludeAdultProperty() {
        let filter = DiscoverTVSeriesFilter(includeAdult: true)

        #expect(filter.includeAdult == true)
    }

    @Test("init with watch providers sets watch providers property")
    func initWithWatchProvidersSetsWatchProvidersProperty() {
        let watchProviders = [8, 9]

        let filter = DiscoverTVSeriesFilter(watchProviders: watchProviders)

        #expect(filter.watchProviders == watchProviders)
    }

    @Test("init with watch region sets watch region property")
    func initWithWatchRegionSetsWatchRegionProperty() {
        let filter = DiscoverTVSeriesFilter(watchRegion: "US")

        #expect(filter.watchRegion == "US")
    }

}
