//
//  DiscoverTVSeriesFilterTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.filters, .discover))
struct DiscoverTVSeriesFilterTests {

    @Test("init with default values creates filter with nil properties")
    func initWithDefaultValuesCreatesFilterWithNilProperties() {
        let filter = DiscoverTVSeriesFilter()

        #expect(filter.originalLanguage == nil)
        #expect(filter.genres == nil)
    }

    @Test("init with original language sets original language property")
    func initWithOriginalLanguageSetsOriginalLanguageProperty() {
        let originalLanguage = "en"

        let filter = DiscoverTVSeriesFilter(originalLanguage: originalLanguage)

        #expect(filter.originalLanguage == originalLanguage)
        #expect(filter.genres == nil)
    }

    @Test("init with genres sets genres property")
    func initWithGenresSetsGenresProperty() {
        let genres = [18, 35, 80]

        let filter = DiscoverTVSeriesFilter(genres: genres)

        #expect(filter.originalLanguage == nil)
        #expect(filter.genres == genres)
    }

    @Test("init with all parameters sets all properties")
    func initWithAllParametersSetsAllProperties() {
        let originalLanguage = "en"
        let genres = [18, 35, 80]

        let filter = DiscoverTVSeriesFilter(
            originalLanguage: originalLanguage,
            genres: genres
        )

        #expect(filter.originalLanguage == originalLanguage)
        #expect(filter.genres == genres)
    }

}
