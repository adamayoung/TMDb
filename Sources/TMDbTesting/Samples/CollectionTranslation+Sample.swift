//
//  CollectionTranslation+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension CollectionTranslation {

    /// A sample `CollectionTranslation` for use in tests and previews.
    static var sample: CollectionTranslation {
        CollectionTranslation(
            countryCode: "DE",
            languageCode: "de",
            name: "Deutsch",
            englishName: "German",
            data: CollectionTranslationData(
                title: "Star Wars Filmreihe",
                overview: """
                "Star Wars™" ist die größte Science-Fiction-Saga aller Zeiten, die mit ihren bislang \
                neun filmischen Episoden alle Dimensionen der Unterhaltungskultur gesprengt hat.
                """,
                homepageURL: URL(string: "http://www.starwars-union.de")
            )
        )
    }

}

public extension [CollectionTranslation] {

    /// A sample array of `CollectionTranslation` values for use in tests and previews.
    static var samples: [CollectionTranslation] {
        [.sample]
    }

}
