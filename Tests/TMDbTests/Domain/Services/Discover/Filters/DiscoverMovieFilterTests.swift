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
struct DiscoverMovieFilterTests {

    @Test("init with default values creates filter with nil properties")
    func initWithDefaultValuesCreatesFilterWithNilProperties() {
        let filter = DiscoverMovieFilter()

        #expect(filter.people == nil)
        #expect(filter.originalLanguage == nil)
        #expect(filter.genres == nil)
        #expect(filter.primaryReleaseYear == nil)
    }

    @Test("init with people sets people property")
    func initWithPeopleSetsPeopleProperty() {
        let people = [1, 2, 3]

        let filter = DiscoverMovieFilter(people: people)

        #expect(filter.people == people)
        #expect(filter.originalLanguage == nil)
        #expect(filter.genres == nil)
        #expect(filter.primaryReleaseYear == nil)
    }

    @Test("init with original language sets original language property")
    func initWithOriginalLanguageSetsOriginalLanguageProperty() {
        let originalLanguage = "en"

        let filter = DiscoverMovieFilter(originalLanguage: originalLanguage)

        #expect(filter.people == nil)
        #expect(filter.originalLanguage == originalLanguage)
        #expect(filter.genres == nil)
        #expect(filter.primaryReleaseYear == nil)
    }

    @Test("init with genres sets genres property")
    func initWithGenresSetsGenresProperty() {
        let genres = [28, 12, 16]

        let filter = DiscoverMovieFilter(genres: genres)

        #expect(filter.people == nil)
        #expect(filter.originalLanguage == nil)
        #expect(filter.genres == genres)
        #expect(filter.primaryReleaseYear == nil)
    }

    @Test("init with primary release year sets primary release year property")
    func initWithPrimaryReleaseYearSetsPrimaryReleaseYearProperty() {
        let primaryReleaseYear = DiscoverMovieFilter.PrimaryReleaseYearFilter.on(2024)

        let filter = DiscoverMovieFilter(primaryReleaseYear: primaryReleaseYear)

        #expect(filter.people == nil)
        #expect(filter.originalLanguage == nil)
        #expect(filter.genres == nil)
        #expect(filter.primaryReleaseYear == primaryReleaseYear)
    }

    @Test("init with all parameters sets all properties")
    func initWithAllParametersSetsAllProperties() {
        let people = [1, 2, 3]
        let originalLanguage = "en"
        let genres = [28, 12, 16]
        let primaryReleaseYear = DiscoverMovieFilter.PrimaryReleaseYearFilter.on(2024)

        let filter = DiscoverMovieFilter(
            people: people,
            originalLanguage: originalLanguage,
            genres: genres,
            primaryReleaseYear: primaryReleaseYear
        )

        #expect(filter.people == people)
        #expect(filter.originalLanguage == originalLanguage)
        #expect(filter.genres == genres)
        #expect(filter.primaryReleaseYear == primaryReleaseYear)
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
        let filter = DiscoverMovieFilter.PrimaryReleaseYearFilter.between(start: 2020, end: 2025)

        let bounds = filter.dateBounds()

        #expect(bounds.gte == "2020-01-01")
        #expect(bounds.lte == "2025-12-31")
    }

}
