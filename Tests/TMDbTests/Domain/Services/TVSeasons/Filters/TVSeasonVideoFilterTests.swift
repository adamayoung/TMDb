//
//  TVSeasonVideoFilterTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.filters, .tvSeason))
struct TVSeasonVideoFilterTests {

    @Test("init with default values creates filter with nil properties")
    func initWithDefaultValuesCreatesFilterWithNilProperties() {
        let filter = TVSeasonVideoFilter()

        #expect(filter.languages == nil)
    }

    @Test("init with languages sets languages property")
    func initWithLanguagesSetsLanguagesProperty() {
        let languages = ["en", "fr", "de"]

        let filter = TVSeasonVideoFilter(languages: languages)

        #expect(filter.languages == languages)
    }

}
