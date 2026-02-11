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
        #expect(filter.year == nil)
        #expect(filter.country == nil)
        #expect(filter.includeAdult == nil)
    }

    @Test("init with primary release year sets primary release year property")
    func initWithPrimaryReleaseYearSetsPrimaryReleaseYearProperty() {
        let filter = MovieSearchFilter(primaryReleaseYear: 2024)

        #expect(filter.primaryReleaseYear == 2024)
    }

    @Test("init with year sets year property")
    func initWithYearSetsYearProperty() {
        let filter = MovieSearchFilter(year: 2024)

        #expect(filter.year == 2024)
    }

    @Test("init with country sets country property")
    func initWithCountrySetsCountryProperty() {
        let filter = MovieSearchFilter(country: "US")

        #expect(filter.country == "US")
    }

    @Test("init with include adult sets include adult property")
    func initWithIncludeAdultSetsIncludeAdultProperty() {
        let filter = MovieSearchFilter(includeAdult: true)

        #expect(filter.includeAdult == true)
    }

    @Test("init with all parameters sets all properties")
    func initWithAllParametersSetsAllProperties() {
        let filter = MovieSearchFilter(
            primaryReleaseYear: 2024,
            year: 2024,
            country: "US",
            includeAdult: true
        )

        #expect(filter.primaryReleaseYear == 2024)
        #expect(filter.year == 2024)
        #expect(filter.country == "US")
        #expect(filter.includeAdult == true)
    }

}
