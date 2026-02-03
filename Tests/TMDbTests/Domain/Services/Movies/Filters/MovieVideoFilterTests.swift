//
//  MovieVideoFilterTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.filters, .movie))
struct MovieVideoFilterTests {

    @Test("init with default values creates filter with nil properties")
    func initWithDefaultValuesCreatesFilterWithNilProperties() {
        let filter = MovieVideoFilter()

        #expect(filter.languages == nil)
    }

    @Test("init with languages sets languages property")
    func initWithLanguagesSetsLanguagesProperty() {
        let languages = ["en", "fr", "de"]

        let filter = MovieVideoFilter(languages: languages)

        #expect(filter.languages == languages)
    }

}
