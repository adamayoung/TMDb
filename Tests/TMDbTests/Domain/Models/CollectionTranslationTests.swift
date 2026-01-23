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

}
