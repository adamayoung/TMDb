//
//  TranslationCollection+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension TranslationCollection {

    static func mock(
        id: Int = 1,
        translations: [Translation<DataType>] = []
    ) -> TranslationCollection<DataType> {
        TranslationCollection(
            id: id,
            translations: translations
        )
    }

}

extension TranslationCollection where DataType == MovieTranslationData {

    static func mock(
        id: Int = 1,
        translations: [Translation<MovieTranslationData>] = [
            Translation(
                countryCode: "US",
                languageCode: "en",
                name: "English",
                englishName: "English",
                data: MovieTranslationData(
                    title: "Test Movie",
                    overview: "Test overview",
                    homepage: "https://example.com",
                    tagline: "Test tagline"
                )
            )
        ]
    ) -> TranslationCollection<MovieTranslationData> {
        TranslationCollection(
            id: id,
            translations: translations
        )
    }

}
