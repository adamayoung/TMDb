//
//  CollectionTranslation+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@testable import TMDb

extension CollectionTranslation {

    static var mock: Self {
        CollectionTranslation(
            countryCode: "DE",
            languageCode: "de",
            name: "Deutsch",
            englishName: "German",
            data: CollectionTranslationData(
                title: "Star Wars Filmreihe",
                // swiftlint:disable:next line_length
                overview: "\"Star Wars™\" ist die größte Science-Fiction-Saga aller Zeiten, die mit ihren bislang neun filmischen Episoden und den unüberschaubaren Verzweigungen alle Dimensionen der Unterhaltungskultur gesprengt hat.",
                homepageURL: URL(string: "http://www.starwars-union.de")
            )
        )
    }

}

extension [CollectionTranslation] {

    static var mocks: [CollectionTranslation] {
        [.mock]
    }

}
