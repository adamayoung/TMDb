//
//  CollectionTranslationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.models))
struct CollectionTranslationTests {

    @Test("CollectionTranslation has correct properties")
    func collectionTranslationHasCorrectProperties() {
        let data = CollectionTranslationData(
            title: "Star Wars Filmreihe",
            overview: "An overview",
            homepageURL: URL(string: "http://www.starwars-union.de")
        )

        let translation = CollectionTranslation(
            countryCode: "DE",
            languageCode: "de",
            name: "Deutsch",
            englishName: "German",
            data: data
        )

        #expect(translation.countryCode == "DE")
        #expect(translation.languageCode == "de")
        #expect(translation.name == "Deutsch")
        #expect(translation.englishName == "German")
        #expect(translation.data.title == "Star Wars Filmreihe")
        #expect(translation.data.overview == "An overview")
        #expect(translation.data.homepageURL == URL(string: "http://www.starwars-union.de"))
        #expect(translation.id == "de")
    }

    @Test("JSON decoding with TMDb decoder")
    func jsonDecodingWithTMDbDecoder() throws {
        let json = """
        {
            "iso_3166_1": "DE",
            "iso_639_1": "de",
            "name": "Deutsch",
            "english_name": "German",
            "data": {
                "title": "Star Wars Filmreihe",
                "overview": "Star Wars overview",
                "homepage": "http://www.starwars-union.de"
            }
        }
        """

        let data = json.data(using: .utf8)!
        let translation = try JSONDecoder.theMovieDatabase.decode(
            CollectionTranslation.self,
            from: data
        )

        #expect(translation.countryCode == "DE")
        #expect(translation.languageCode == "de")
        #expect(translation.name == "Deutsch")
        #expect(translation.englishName == "German")
        #expect(translation.data.title == "Star Wars Filmreihe")
        #expect(translation.data.overview == "Star Wars overview")
        #expect(translation.data.homepageURL == URL(string: "http://www.starwars-union.de"))
    }

    @Test("JSON encoding and decoding round trip with TMDb decoder")
    func jsonEncodingAndDecodingRoundTripWithTMDbDecoder() throws {
        let data = CollectionTranslationData(
            title: "Star Wars Filmreihe",
            overview: "An overview",
            homepageURL: URL(string: "http://www.starwars-union.de")
        )

        let original = CollectionTranslation(
            countryCode: "DE",
            languageCode: "de",
            name: "Deutsch",
            englishName: "German",
            data: data
        )

        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let jsonData = try encoder.encode(original)

        let decoder = JSONDecoder.theMovieDatabase
        let decoded = try decoder.decode(CollectionTranslation.self, from: jsonData)

        #expect(decoded.countryCode == original.countryCode)
        #expect(decoded.languageCode == original.languageCode)
        #expect(decoded.name == original.name)
        #expect(decoded.englishName == original.englishName)
        #expect(decoded.data.title == original.data.title)
        #expect(decoded.data.overview == original.data.overview)
        #expect(decoded.data.homepageURL == original.data.homepageURL)
    }

    @Test("JSON decoding from file with multiple translations")
    func jsonDecodingFromFileWithMultipleTranslations() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            CollectionTranslationsResult.self,
            fromResource: "collection-translations-single"
        )

        #expect(result.id == 10)
        #expect(result.translations.count == 2)

        // Verify German translation
        let germanTranslation = try #require(result.translations.first { $0.languageCode == "de" })
        #expect(germanTranslation.countryCode == "DE")
        #expect(germanTranslation.name == "Deutsch")
        #expect(germanTranslation.englishName == "German")
        #expect(germanTranslation.data.title == "Star Wars Filmreihe")
        #expect(germanTranslation.data.homepageURL == URL(string: "http://www.starwars-union.de"))

        // Verify English translation
        let englishTranslation = try #require(result.translations.first { $0.languageCode == "en" })
        #expect(englishTranslation.countryCode == "US")
        #expect(englishTranslation.name == "English")
        #expect(englishTranslation.englishName == "English")
        #expect(englishTranslation.data.title == "")
        #expect(englishTranslation.data.homepageURL == URL(string: "https://www.starwars.com/films"))
    }

}
