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

    /// The TV variant differs from the movie one by carrying `name` where the
    /// movie carries `title`, and nothing decoded it from JSON until now.
    @Test("JSON decoding of TranslationCollection for TV series", .tags(.decoding))
    func decodeTVSeriesTranslationCollection() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            TranslationCollection<TVSeriesTranslationData>.self,
            fromResource: "tv-series-translations"
        )

        #expect(result.id == 1396)
        #expect(result.translations.count == 2)

        // TMDb leaves `name` empty for the original-language translation.
        let enTranslation = try #require(result.translations.first { $0.languageCode == "en" })
        #expect(enTranslation.countryCode == "US")
        #expect(enTranslation.name == "English")
        #expect(enTranslation.englishName == "English")
        #expect(enTranslation.data.name == "")
        #expect(enTranslation.data.tagline == "Change the equation.")

        // Asserted in full rather than with `contains`: a substring match is
        // what let a hand-truncated overview into this fixture in the first
        // place, and it would not catch the next one.
        #expect(
            enTranslation.data.overview == """
            Walter White, a New Mexico chemistry teacher, is diagnosed with Stage III cancer and given a \
            prognosis of only two years left to live. He becomes filled with a sense of fearlessness and an \
            unrelenting desire to secure his family's financial future at any cost as he enters the \
            dangerous world of drugs and crime.
            """
        )

        let skTranslation = try #require(result.translations.first { $0.languageCode == "sk" })
        #expect(skTranslation.countryCode == "SK")
        #expect(skTranslation.englishName == "Slovak")
        #expect(skTranslation.data.name == "Perníkový tatko")
        #expect(skTranslation.data.tagline == "")
        #expect(
            skTranslation.data.overview == """
            Stredoškolskému učiteľovi chémie je diagnostikovaná rakovina a tak sa rozhodne pred svojou \
            smrťou zaopatriť výrobou metam\u{00AD}fetamínu svoju rodinu. Seriál vyniká úplne famóznou \
            premenou hlavnej postavy z obyčajného človeka na kľúčovú postavu drogového obchodu a \
            skutočného bossa.
            """
        )

        // `homepage` is an empty string on every TV translation TMDb returns —
        // it is typed String?, so it decodes as "" rather than nil.
        #expect(enTranslation.data.homepage == "")
        #expect(skTranslation.data.homepage == "")
    }

}
