//
//  TranslationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct TranslationTests {

    @Test("JSON decoding of TranslationCollection for movies", .tags(.decoding))
    func decodeMovieTranslationCollection() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            TranslationCollection<MovieTranslationData>.self,
            fromResource: "movie-translation-collection"
        )

        #expect(result.id == 550)
        #expect(result.translations.count == 2)

        let enTranslation = try #require(result.translations.first { $0.languageCode == "en" })
        #expect(enTranslation.countryCode == "US")
        #expect(enTranslation.name == "English")
        #expect(enTranslation.englishName == "English")
        #expect(enTranslation.data.title == "Fight Club")
        #expect(enTranslation.data.overview.contains("insomniac"))
        #expect(enTranslation.data.homepage == "https://www.foxmovies.com/movies/fight-club")
        #expect(enTranslation.data.tagline == "Mischief. Mayhem. Soap.")

        let frTranslation = try #require(result.translations.first { $0.languageCode == "fr" })
        #expect(frTranslation.countryCode == "FR")
        #expect(frTranslation.name == "Français")
        #expect(frTranslation.englishName == "French")
        #expect(frTranslation.data.homepage == nil)
        #expect(frTranslation.data.tagline == nil)
    }

}
