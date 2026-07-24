//
//  TranslationCollection+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

package extension TranslationCollection {

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

package extension TranslationCollection where DataType == MovieTranslationData {

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

package extension TranslationCollection where DataType == TVSeriesTranslationData {

    static func mock(
        id: Int = 1,
        translations: [Translation<TVSeriesTranslationData>] = [
            Translation(
                countryCode: "US",
                languageCode: "en",
                name: "English",
                englishName: "English",
                data: TVSeriesTranslationData(
                    name: "Test TV Series",
                    overview: "Test overview",
                    homepage: "https://example.com",
                    tagline: "Test tagline"
                )
            )
        ]
    ) -> TranslationCollection<TVSeriesTranslationData> {
        TranslationCollection(
            id: id,
            translations: translations
        )
    }

}

package extension TranslationCollection where DataType == TVSeasonTranslationData {

    static func mock(
        id: Int = 1,
        translations: [Translation<TVSeasonTranslationData>] = [
            Translation(
                countryCode: "US",
                languageCode: "en",
                name: "English",
                englishName: "English",
                data: TVSeasonTranslationData(
                    name: "Test TV Season",
                    overview: "Test overview"
                )
            )
        ]
    ) -> TranslationCollection<TVSeasonTranslationData> {
        TranslationCollection(
            id: id,
            translations: translations
        )
    }

}

package extension TranslationCollection where DataType == TVEpisodeTranslationData {

    static func mock(
        id: Int = 1,
        translations: [Translation<TVEpisodeTranslationData>] = [
            Translation(
                countryCode: "US",
                languageCode: "en",
                name: "English",
                englishName: "English",
                data: TVEpisodeTranslationData(
                    name: "Test TV Episode",
                    overview: "Test overview"
                )
            )
        ]
    ) -> TranslationCollection<TVEpisodeTranslationData> {
        TranslationCollection(
            id: id,
            translations: translations
        )
    }

}
