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
struct DiscoverTVSeriesFilterTests { // swiftlint:disable:this type_body_length

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
        #expect(filter.withOriginCountry == nil)
        #expect(filter.withStatus == nil)
        #expect(filter.withType == nil)
        #expect(filter.withoutCompanies == nil)
        #expect(filter.watchMonetizationTypes == nil)
        #expect(filter.screenedTheatrically == nil)
        #expect(filter.withPeople == nil)
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

    @Test("init with origin country sets property")
    func initWithOriginCountrySetsProperty() {
        let filter = DiscoverTVSeriesFilter(withOriginCountry: "US")

        #expect(filter.withOriginCountry == "US")
    }

    @Test("init with status sets property")
    func initWithStatusSetsProperty() {
        let withStatus = [0, 3]

        let filter = DiscoverTVSeriesFilter(withStatus: withStatus)

        #expect(filter.withStatus == withStatus)
    }

    @Test("init with type sets property")
    func initWithTypeSetsProperty() {
        let withType = [2, 4]

        let filter = DiscoverTVSeriesFilter(withType: withType)

        #expect(filter.withType == withType)
    }

    @Test("init with without companies sets property")
    func initWithWithoutCompaniesSetsProperty() {
        let withoutCompanies = [420, 7505]

        let filter = DiscoverTVSeriesFilter(
            withoutCompanies: withoutCompanies
        )

        #expect(filter.withoutCompanies == withoutCompanies)
    }

    @Test("init with watch monetization types sets property")
    func initWithWatchMonetizationTypesSetsProperty() {
        let types: [WatchMonetizationType] = [.flatrate, .buy]

        let filter = DiscoverTVSeriesFilter(
            watchMonetizationTypes: types
        )

        #expect(filter.watchMonetizationTypes == types)
    }

    @Test("init with screened theatrically sets property")
    func initWithScreenedTheatricallySetsProperty() {
        let filter = DiscoverTVSeriesFilter(
            screenedTheatrically: true
        )

        #expect(filter.screenedTheatrically == true)
    }

    @Test("init with people sets with people property")
    func initWithPeopleSetsWithPeopleProperty() {
        let withPeople = [287, 819]

        let filter = DiscoverTVSeriesFilter(withPeople: withPeople)

        #expect(filter.withPeople == withPeople)
    }

    @Test("init with all parameters sets all properties")
    func initWithAllParametersSetsAllProperties() { // swiftlint:disable:this function_body_length
        let firstAirDateMin = Date(iso8601: "2024-01-01T00:00:00Z")
        let firstAirDateMax = Date(iso8601: "2024-12-31T00:00:00Z")
        let airDateMin = Date(iso8601: "2024-06-01T00:00:00Z")
        let airDateMax = Date(iso8601: "2024-06-30T00:00:00Z")

        let monetizationTypes: [WatchMonetizationType] = [
            .flatrate, .rent
        ]

        let filter = DiscoverTVSeriesFilter(
            originalLanguage: "en",
            genres: [18, 35],
            withoutGenres: [27, 53],
            firstAirDateYear: 2024,
            firstAirDateMin: firstAirDateMin,
            firstAirDateMax: firstAirDateMax,
            airDateMin: airDateMin,
            airDateMax: airDateMax,
            voteAverageMin: 7.0,
            voteAverageMax: 10.0,
            voteCountMin: 100,
            voteCountMax: 1000,
            networks: [213, 1024],
            companies: [100, 200],
            keywords: [10, 20],
            withoutKeywords: [30, 40],
            runtimeMin: 30,
            runtimeMax: 60,
            includeAdult: false,
            watchProviders: [8, 9],
            watchRegion: "US",
            withOriginCountry: "US",
            withStatus: [0, 3],
            withType: [4],
            withoutCompanies: [999],
            watchMonetizationTypes: monetizationTypes,
            screenedTheatrically: true,
            withPeople: [287]
        )

        #expect(filter.originalLanguage == "en")
        #expect(filter.genres == [18, 35])
        #expect(filter.withoutGenres == [27, 53])
        #expect(filter.firstAirDateYear == 2024)
        #expect(filter.firstAirDateMin == firstAirDateMin)
        #expect(filter.firstAirDateMax == firstAirDateMax)
        #expect(filter.airDateMin == airDateMin)
        #expect(filter.airDateMax == airDateMax)
        #expect(filter.voteAverageMin == 7.0)
        #expect(filter.voteAverageMax == 10.0)
        #expect(filter.voteCountMin == 100)
        #expect(filter.voteCountMax == 1000)
        #expect(filter.networks == [213, 1024])
        #expect(filter.companies == [100, 200])
        #expect(filter.keywords == [10, 20])
        #expect(filter.withoutKeywords == [30, 40])
        #expect(filter.runtimeMin == 30)
        #expect(filter.runtimeMax == 60)
        #expect(filter.includeAdult == false)
        #expect(filter.watchProviders == [8, 9])
        #expect(filter.watchRegion == "US")
        #expect(filter.withOriginCountry == "US")
        #expect(filter.withStatus == [0, 3])
        #expect(filter.withType == [4])
        #expect(filter.withoutCompanies == [999])
        #expect(filter.watchMonetizationTypes == monetizationTypes)
        #expect(filter.screenedTheatrically == true)
        #expect(filter.withPeople == [287])
    }

}
