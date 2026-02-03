//
//  TVSeriesSearchFilterTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.filters, .search))
struct TVSeriesSearchFilterTests {

    @Test("init with default values creates filter with nil properties")
    func initWithDefaultValuesCreatesFilterWithNilProperties() {
        let filter = TVSeriesSearchFilter(firstAirDateYear: nil, year: nil, includeAdult: nil)

        #expect(filter.firstAirDateYear == nil)
        #expect(filter.year == nil)
        #expect(filter.includeAdult == nil)
    }

    @Test("init with first air date year sets first air date year property")
    func initWithFirstAirDateYearSetsFirstAirDateYearProperty() {
        let firstAirDateYear = 2024

        let filter = TVSeriesSearchFilter(firstAirDateYear: firstAirDateYear, year: nil, includeAdult: nil)

        #expect(filter.firstAirDateYear == firstAirDateYear)
        #expect(filter.year == nil)
        #expect(filter.includeAdult == nil)
    }

    @Test("init with year sets year property")
    func initWithYearSetsYearProperty() {
        let year = 2024

        let filter = TVSeriesSearchFilter(firstAirDateYear: nil, year: year, includeAdult: nil)

        #expect(filter.firstAirDateYear == nil)
        #expect(filter.year == year)
        #expect(filter.includeAdult == nil)
    }

    @Test("init with include adult sets include adult property")
    func initWithIncludeAdultSetsIncludeAdultProperty() {
        let includeAdult = true

        let filter = TVSeriesSearchFilter(firstAirDateYear: nil, year: nil, includeAdult: includeAdult)

        #expect(filter.firstAirDateYear == nil)
        #expect(filter.year == nil)
        #expect(filter.includeAdult == includeAdult)
    }

    @Test("init with all parameters sets all properties")
    func initWithAllParametersSetsAllProperties() {
        let firstAirDateYear = 2024
        let year = 2023
        let includeAdult = true

        let filter = TVSeriesSearchFilter(
            firstAirDateYear: firstAirDateYear,
            year: year,
            includeAdult: includeAdult
        )

        #expect(filter.firstAirDateYear == firstAirDateYear)
        #expect(filter.year == year)
        #expect(filter.includeAdult == includeAdult)
    }

}
