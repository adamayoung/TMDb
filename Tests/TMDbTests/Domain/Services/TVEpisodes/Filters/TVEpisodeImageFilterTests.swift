//
//  TVEpisodeImageFilterTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.filters, .tvEpisode))
struct TVEpisodeImageFilterTests {

    @Test("init with default values creates filter with nil properties")
    func initWithDefaultValuesCreatesFilterWithNilProperties() {
        let filter = TVEpisodeImageFilter()

        #expect(filter.languages == nil)
    }

    @Test("init with languages sets languages property")
    func initWithLanguagesSetsLanguagesProperty() {
        let languages = ["en", "fr", "de"]

        let filter = TVEpisodeImageFilter(languages: languages)

        #expect(filter.languages == languages)
    }

}
