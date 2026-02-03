//
//  TVEpisodeVideoFilterTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.filters, .tvEpisode))
struct TVEpisodeVideoFilterTests {

    @Test("init with default values creates filter with nil properties")
    func initWithDefaultValuesCreatesFilterWithNilProperties() {
        let filter = TVEpisodeVideoFilter()

        #expect(filter.languages == nil)
    }

    @Test("init with languages sets languages property")
    func initWithLanguagesSetsLanguagesProperty() {
        let languages = ["en", "fr", "de"]

        let filter = TVEpisodeVideoFilter(languages: languages)

        #expect(filter.languages == languages)
    }

}
