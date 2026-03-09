//
//  DiscoverMovieFilterTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.filters, .discover))
struct DiscoverMovieFilterTests { // swiftlint:disable:this type_body_length

    @Test("init with default values creates filter with nil properties")
    func initWithDefaultValuesCreatesFilterWithNilProperties() {
        let filter = DiscoverMovieFilter()

        #expect(filter.people == nil)
        #expect(filter.originalLanguage == nil)
        #expect(filter.genres == nil)
        #expect(filter.withoutGenres == nil)
        #expect(filter.primaryReleaseYear == nil)
        #expect(filter.voteAverageMin == nil)
        #expect(filter.voteAverageMax == nil)
        #expect(filter.voteCountMin == nil)
        #expect(filter.voteCountMax == nil)
        #expect(filter.companies == nil)
        #expect(filter.keywords == nil)
        #expect(filter.withoutKeywords == nil)
        #expect(filter.runtimeMin == nil)
        #expect(filter.runtimeMax == nil)
        #expect(filter.includeAdult == nil)
        #expect(filter.includeVideo == nil)
        #expect(filter.watchProviders == nil)
        #expect(filter.watchRegion == nil)
        #expect(filter.certification == nil)
        #expect(filter.certificationMin == nil)
        #expect(filter.certificationMax == nil)
        #expect(filter.certificationCountry == nil)
        #expect(filter.releaseTypes == nil)
        #expect(filter.withCast == nil)
        #expect(filter.withCrew == nil)
        #expect(filter.withOriginCountry == nil)
        #expect(filter.withoutCompanies == nil)
        #expect(filter.watchMonetizationTypes == nil)
    }

    @Test("init with people sets people property")
    func initWithPeopleSetsPeopleProperty() {
        let people = [1, 2, 3]

        let filter = DiscoverMovieFilter(people: people)

        #expect(filter.people == people)
    }

    @Test("init with original language sets original language property")
    func initWithOriginalLanguageSetsOriginalLanguageProperty() {
        let filter = DiscoverMovieFilter(originalLanguage: "en")

        #expect(filter.originalLanguage == "en")
    }

    @Test("init with genres sets genres property")
    func initWithGenresSetsGenresProperty() {
        let genres = [28, 12, 16]

        let filter = DiscoverMovieFilter(genres: genres)

        #expect(filter.genres == genres)
    }

    @Test("init with without genres sets without genres property")
    func initWithWithoutGenresSetsWithoutGenresProperty() {
        let withoutGenres = [27, 53]

        let filter = DiscoverMovieFilter(withoutGenres: withoutGenres)

        #expect(filter.withoutGenres == withoutGenres)
    }

    @Test("init with primary release year sets primary release year property")
    func initWithPrimaryReleaseYearSetsPrimaryReleaseYearProperty() {
        let primaryReleaseYear = DiscoverMovieFilter
            .PrimaryReleaseYearFilter.on(2024)

        let filter = DiscoverMovieFilter(
            primaryReleaseYear: primaryReleaseYear
        )

        #expect(filter.primaryReleaseYear == primaryReleaseYear)
    }

    @Test("init with vote average range sets vote average properties")
    func initWithVoteAverageRangeSetsVoteAverageProperties() {
        let filter = DiscoverMovieFilter(
            voteAverageMin: 7.0,
            voteAverageMax: 10.0
        )

        #expect(filter.voteAverageMin == 7.0)
        #expect(filter.voteAverageMax == 10.0)
    }

    @Test("init with vote count range sets vote count properties")
    func initWithVoteCountRangeSetsVoteCountProperties() {
        let filter = DiscoverMovieFilter(
            voteCountMin: 100,
            voteCountMax: 1000
        )

        #expect(filter.voteCountMin == 100)
        #expect(filter.voteCountMax == 1000)
    }

    @Test("init with companies sets companies property")
    func initWithCompaniesSetesCompaniesProperty() {
        let companies = [1, 2]

        let filter = DiscoverMovieFilter(companies: companies)

        #expect(filter.companies == companies)
    }

    @Test("init with keywords sets keywords property")
    func initWithKeywordsSetsKeywordsProperty() {
        let keywords = [10, 20]

        let filter = DiscoverMovieFilter(keywords: keywords)

        #expect(filter.keywords == keywords)
    }

    @Test("init with without keywords sets without keywords property")
    func initWithWithoutKeywordsSetsWithoutKeywordsProperty() {
        let withoutKeywords = [30, 40]

        let filter = DiscoverMovieFilter(withoutKeywords: withoutKeywords)

        #expect(filter.withoutKeywords == withoutKeywords)
    }

    @Test("init with runtime range sets runtime properties")
    func initWithRuntimeRangeSetsRuntimeProperties() {
        let filter = DiscoverMovieFilter(runtimeMin: 90, runtimeMax: 180)

        #expect(filter.runtimeMin == 90)
        #expect(filter.runtimeMax == 180)
    }

    @Test("init with include adult sets include adult property")
    func initWithIncludeAdultSetsIncludeAdultProperty() {
        let filter = DiscoverMovieFilter(includeAdult: true)

        #expect(filter.includeAdult == true)
    }

    @Test("init with include video sets include video property")
    func initWithIncludeVideoSetsIncludeVideoProperty() {
        let filter = DiscoverMovieFilter(includeVideo: true)

        #expect(filter.includeVideo == true)
    }

    @Test("init with watch providers sets watch providers property")
    func initWithWatchProvidersSetsWatchProvidersProperty() {
        let watchProviders = [8, 9]

        let filter = DiscoverMovieFilter(watchProviders: watchProviders)

        #expect(filter.watchProviders == watchProviders)
    }

    @Test("init with watch region sets watch region property")
    func initWithWatchRegionSetsWatchRegionProperty() {
        let filter = DiscoverMovieFilter(watchRegion: "US")

        #expect(filter.watchRegion == "US")
    }

    @Test("init with certification sets certification property")
    func initWithCertificationSetsCertificationProperty() {
        let filter = DiscoverMovieFilter(certification: "PG-13")

        #expect(filter.certification == "PG-13")
    }

    @Test("init with certification min sets property")
    func initWithCertificationMinSetsCertificationMinProperty() {
        let filter = DiscoverMovieFilter(certificationMin: "G")

        #expect(filter.certificationMin == "G")
    }

    @Test("init with certification max sets property")
    func initWithCertificationMaxSetsCertificationMaxProperty() {
        let filter = DiscoverMovieFilter(certificationMax: "R")

        #expect(filter.certificationMax == "R")
    }

    @Test("init with certification country sets property")
    func initWithCertificationCountrySetsProperty() {
        let filter = DiscoverMovieFilter(certificationCountry: "US")

        #expect(filter.certificationCountry == "US")
    }

    @Test("init with release types sets property")
    func initWithReleaseTypesSetsProperty() {
        let releaseTypes = [3, 4]

        let filter = DiscoverMovieFilter(releaseTypes: releaseTypes)

        #expect(filter.releaseTypes == releaseTypes)
    }

    @Test("init with cast sets with cast property")
    func initWithCastSetsWithCastProperty() {
        let withCast = [287, 819]

        let filter = DiscoverMovieFilter(withCast: withCast)

        #expect(filter.withCast == withCast)
    }

    @Test("init with crew sets with crew property")
    func initWithCrewSetsWithCrewProperty() {
        let withCrew = [1223, 5678]

        let filter = DiscoverMovieFilter(withCrew: withCrew)

        #expect(filter.withCrew == withCrew)
    }

    @Test("init with origin country sets property")
    func initWithOriginCountrySetsProperty() {
        let filter = DiscoverMovieFilter(withOriginCountry: "US")

        #expect(filter.withOriginCountry == "US")
    }

    @Test("init with without companies sets property")
    func initWithWithoutCompaniesSetsProperty() {
        let withoutCompanies = [420, 7505]

        let filter = DiscoverMovieFilter(
            withoutCompanies: withoutCompanies
        )

        #expect(filter.withoutCompanies == withoutCompanies)
    }

    @Test("init with watch monetization types sets property")
    func initWithWatchMonetizationTypesSetsProperty() {
        let types: [WatchMonetizationType] = [.flatrate, .free]

        let filter = DiscoverMovieFilter(
            watchMonetizationTypes: types
        )

        #expect(filter.watchMonetizationTypes == types)
    }

    @Test("init with all parameters sets all properties")
    func initWithAllParametersSetsAllProperties() { // swiftlint:disable:this function_body_length
        let people = [1, 2, 3]
        let genres = [28, 12]
        let withoutGenres = [27, 53]
        let primaryReleaseYear = DiscoverMovieFilter
            .PrimaryReleaseYearFilter.on(2024)
        let companies = [100, 200]
        let keywords = [10, 20]
        let withoutKeywords = [30, 40]
        let watchProviders = [8, 9]

        let withoutCompanies = [999]
        let monetizationTypes: [WatchMonetizationType] = [
            .flatrate, .rent
        ]

        let filter = DiscoverMovieFilter(
            people: people,
            originalLanguage: "en",
            genres: genres,
            withoutGenres: withoutGenres,
            primaryReleaseYear: primaryReleaseYear,
            voteAverageMin: 7.0,
            voteAverageMax: 10.0,
            voteCountMin: 100,
            voteCountMax: 1000,
            companies: companies,
            keywords: keywords,
            withoutKeywords: withoutKeywords,
            runtimeMin: 90,
            runtimeMax: 180,
            includeAdult: false,
            includeVideo: true,
            watchProviders: watchProviders,
            watchRegion: "US",
            certification: "PG-13",
            certificationMin: "G",
            certificationMax: "R",
            certificationCountry: "US",
            releaseTypes: [3, 4],
            withCast: [287],
            withCrew: [1223],
            withOriginCountry: "US",
            withoutCompanies: withoutCompanies,
            watchMonetizationTypes: monetizationTypes
        )

        #expect(filter.people == people)
        #expect(filter.originalLanguage == "en")
        #expect(filter.genres == genres)
        #expect(filter.withoutGenres == withoutGenres)
        #expect(filter.primaryReleaseYear == primaryReleaseYear)
        #expect(filter.voteAverageMin == 7.0)
        #expect(filter.voteAverageMax == 10.0)
        #expect(filter.voteCountMin == 100)
        #expect(filter.voteCountMax == 1000)
        #expect(filter.companies == companies)
        #expect(filter.keywords == keywords)
        #expect(filter.withoutKeywords == withoutKeywords)
        #expect(filter.runtimeMin == 90)
        #expect(filter.runtimeMax == 180)
        #expect(filter.includeAdult == false)
        #expect(filter.includeVideo == true)
        #expect(filter.watchProviders == watchProviders)
        #expect(filter.watchRegion == "US")
        #expect(filter.certification == "PG-13")
        #expect(filter.certificationMin == "G")
        #expect(filter.certificationMax == "R")
        #expect(filter.certificationCountry == "US")
        #expect(filter.releaseTypes == [3, 4])
        #expect(filter.withCast == [287])
        #expect(filter.withCrew == [1223])
        #expect(filter.withOriginCountry == "US")
        #expect(filter.withoutCompanies == withoutCompanies)
        #expect(filter.watchMonetizationTypes == monetizationTypes)
    }

    @Test("primary release year filter on returns correct date bounds")
    func primaryReleaseYearFilterOnReturnsCorrectDateBounds() {
        let filter = DiscoverMovieFilter.PrimaryReleaseYearFilter.on(2024)

        let bounds = filter.dateBounds()

        #expect(bounds.gte == "2024-01-01")
        #expect(bounds.lte == "2024-12-31")
    }

    @Test("primary release year filter from returns correct date bounds")
    func primaryReleaseYearFilterFromReturnsCorrectDateBounds() {
        let filter = DiscoverMovieFilter.PrimaryReleaseYearFilter.from(2020)

        let bounds = filter.dateBounds()

        #expect(bounds.gte == "2020-01-01")
        #expect(bounds.lte == nil)
    }

    @Test("primary release year filter up to returns correct date bounds")
    func primaryReleaseYearFilterUpToReturnsCorrectDateBounds() {
        let filter = DiscoverMovieFilter.PrimaryReleaseYearFilter.upTo(2025)

        let bounds = filter.dateBounds()

        #expect(bounds.gte == nil)
        #expect(bounds.lte == "2025-12-31")
    }

    @Test("primary release year filter between returns correct date bounds")
    func primaryReleaseYearFilterBetweenReturnsCorrectDateBounds() {
        let filter = DiscoverMovieFilter.PrimaryReleaseYearFilter.between(
            start: 2020,
            end: 2025
        )

        let bounds = filter.dateBounds()

        #expect(bounds.gte == "2020-01-01")
        #expect(bounds.lte == "2025-12-31")
    }

}
