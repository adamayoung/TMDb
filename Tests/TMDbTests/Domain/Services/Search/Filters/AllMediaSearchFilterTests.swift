//
//  AllMediaSearchFilterTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.filters, .search))
struct AllMediaSearchFilterTests {

    @Test("init with default values creates filter with nil properties")
    func initWithDefaultValuesCreatesFilterWithNilProperties() {
        let filter = AllMediaSearchFilter()

        #expect(filter.includeAdult == nil)
    }

    @Test("init with include adult sets include adult property")
    func initWithIncludeAdultSetsIncludeAdultProperty() {
        let includeAdult = true

        let filter = AllMediaSearchFilter(includeAdult: includeAdult)

        #expect(filter.includeAdult == includeAdult)
    }

}
