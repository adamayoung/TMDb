//
//  WatchProviderFilterTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.filters, .watchProvider))
struct WatchProviderFilterTests {

    @Test("init with default values creates filter with nil properties")
    func initWithDefaultValuesCreatesFilterWithNilProperties() {
        let filter = WatchProviderFilter()

        #expect(filter.country == nil)
    }

    @Test("init with country sets country property")
    func initWithCountrySetsCountryProperty() {
        let country = "US"

        let filter = WatchProviderFilter(country: country)

        #expect(filter.country == country)
    }

}
