//
//  MovieSearchFilterTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.filters, .search))
struct MovieSearchFilterTests {

    @Test("init with default values creates filter with nil properties")
    func initWithDefaultValuesCreatesFilterWithNilProperties() {
        let filter = MovieSearchFilter()

        #expect(filter.primaryReleaseYear == nil)
        #expect(filter.country == nil)
        #expect(filter.includeAdult == nil)
    }

    @Test("init with primary release year sets primary release year property")
    func initWithPrimaryReleaseYearSetsPrimaryReleaseYearProperty() {
        let primaryReleaseYear = 2024

        let filter = MovieSearchFilter(primaryReleaseYear: primaryReleaseYear)

        #expect(filter.primaryReleaseYear == primaryReleaseYear)
        #expect(filter.country == nil)
        #expect(filter.includeAdult == nil)
    }

    @Test("init with country sets country property")
    func initWithCountrySetsCountryProperty() {
        let country = "US"

        let filter = MovieSearchFilter(country: country)

        #expect(filter.primaryReleaseYear == nil)
        #expect(filter.country == country)
        #expect(filter.includeAdult == nil)
    }

    @Test("init with include adult sets include adult property")
    func initWithIncludeAdultSetsIncludeAdultProperty() {
        let includeAdult = true

        let filter = MovieSearchFilter(includeAdult: includeAdult)

        #expect(filter.primaryReleaseYear == nil)
        #expect(filter.country == nil)
        #expect(filter.includeAdult == includeAdult)
    }

    @Test("init with all parameters sets all properties")
    func initWithAllParametersSetsAllProperties() {
        let primaryReleaseYear = 2024
        let country = "US"
        let includeAdult = true

        let filter = MovieSearchFilter(
            primaryReleaseYear: primaryReleaseYear,
            country: country,
            includeAdult: includeAdult
        )

        #expect(filter.primaryReleaseYear == primaryReleaseYear)
        #expect(filter.country == country)
        #expect(filter.includeAdult == includeAdult)
    }

}
