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
                        title: "",
                        overview: "A ticking-time-bomb insomniac and a slippery soap salesman "
                            + "channel primal male aggression into a shocking new form of "
                            + "therapy. Their concept catches on, with underground \"fight "
                            + "clubs\" forming in every town, until an eccentric gets in the "
                            + "way and ignites an out-of-control spiral toward oblivion.",
                        homepage: "https://www.20thcenturystudios.com/movies/fight-club",
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
                        biography: "William Bradley Pitt (born December 18, 1963) is an "
                            + "American actor and film producer. In a film career spanning "
                            + "more than thirty years, Pitt has received numerous accolades, "
                            + "including two Academy Awards."
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
            id: 63056,
            translations: [
                Translation(
                    countryCode: "US",
                    languageCode: "en",
                    name: "English",
                    englishName: "English",
                    data: TVEpisodeTranslationData(
                        name: "Winter Is Coming",
                        overview: "Jon Arryn, the Hand of the King, is dead. King Robert "
                            + "Baratheon plans to ask his oldest friend, Eddard Stark, to take "
                            + "Jon's place. Across the sea, Viserys Targaryen plans to wed his "
                            + "sister to a nomadic warlord in exchange for an army."
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
                        name: "",
                        overview: "Trouble is brewing in the Seven Kingdoms of Westeros. For "
                            + "the driven inhabitants of this visionary world, control of "
                            + "Westeros' Iron Throne holds the lure of great power. But in a "
                            + "land where the seasons can last a lifetime, winter is coming..."
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
                        name: "",
                        overview: "Seven noble families fight for control of the mythical land "
                            + "of Westeros. Friction between the houses leads to full-scale "
                            + "war. All while a very ancient evil awakens in the farthest "
                            + "north.",
                        homepage: "",
                        tagline: "Winter is coming."
                    )
                )
            ]
        )
    }

}
