//
//  PersonSearchFilterTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.filters, .search))
struct PersonSearchFilterTests {

    @Test("init with default values creates filter with nil properties")
    func initWithDefaultValuesCreatesFilterWithNilProperties() {
        let filter = PersonSearchFilter()

        #expect(filter.includeAdult == nil)
    }

    @Test("init with include adult sets include adult property")
    func initWithIncludeAdultSetsIncludeAdultProperty() {
        let includeAdult = true

        let filter = PersonSearchFilter(includeAdult: includeAdult)

        #expect(filter.includeAdult == includeAdult)
    }

}
