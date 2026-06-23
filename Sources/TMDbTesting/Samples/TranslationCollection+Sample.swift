//
//  TranslationCollection+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension TranslationCollection where DataType == MovieTranslationData {

    ///
    /// A sample collection of movie translations, for use in tests and previews.
    ///
    static var sample: TranslationCollection<MovieTranslationData> {
        TranslationCollection(
            id: 550,
            translations: [
                Translation(
                    countryCode: "US",
                    languageCode: "en",
                    name: "English",
                    englishName: "English",
                    data: MovieTranslationData(
                        title: "Fight Club",
                        overview: "An insomniac office worker forms an underground club.",
                        homepage: "https://www.foxmovies.com/movies/fight-club",
                        tagline: "Mischief. Mayhem. Soap."
                    )
                )
            ]
        )
    }

}

public extension TranslationCollection where DataType == PersonTranslationData {

    ///
    /// A sample collection of person translations, for use in tests and previews.
    ///
    static var sample: TranslationCollection<PersonTranslationData> {
        TranslationCollection(
            id: 287,
            translations: [
                Translation(
                    countryCode: "US",
                    languageCode: "en",
                    name: "English",
                    englishName: "English",
                    data: PersonTranslationData(
                        biography: "An American actor and film producer."
                    )
                )
            ]
        )
    }

}

public extension TranslationCollection where DataType == TVEpisodeTranslationData {

    ///
    /// A sample collection of TV episode translations, for use in tests and previews.
    ///
    static var sample: TranslationCollection<TVEpisodeTranslationData> {
        TranslationCollection(
            id: 62085,
            translations: [
                Translation(
                    countryCode: "US",
                    languageCode: "en",
                    name: "English",
                    englishName: "English",
                    data: TVEpisodeTranslationData(
                        name: "Pilot",
                        overview: "The first episode of the series."
                    )
                )
            ]
        )
    }

}

public extension TranslationCollection where DataType == TVSeasonTranslationData {

    ///
    /// A sample collection of TV season translations, for use in tests and previews.
    ///
    static var sample: TranslationCollection<TVSeasonTranslationData> {
        TranslationCollection(
            id: 3624,
            translations: [
                Translation(
                    countryCode: "US",
                    languageCode: "en",
                    name: "English",
                    englishName: "English",
                    data: TVSeasonTranslationData(
                        name: "Season 1",
                        overview: "The first season of the series."
                    )
                )
            ]
        )
    }

}

public extension TranslationCollection where DataType == TVSeriesTranslationData {

    ///
    /// A sample collection of TV series translations, for use in tests and previews.
    ///
    static var sample: TranslationCollection<TVSeriesTranslationData> {
        TranslationCollection(
            id: 1399,
            translations: [
                Translation(
                    countryCode: "US",
                    languageCode: "en",
                    name: "English",
                    englishName: "English",
                    data: TVSeriesTranslationData(
                        name: "Game of Thrones",
                        overview: "Seven noble families fight for control of the land of Westeros.",
                        homepage: "https://www.hbo.com/game-of-thrones",
                        tagline: "Winter is coming."
                    )
                )
            ]
        )
    }

}
