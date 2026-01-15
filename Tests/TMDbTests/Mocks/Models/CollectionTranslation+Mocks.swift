//
//  CollectionTranslation+Mocks.swift
//  TMDb
//
//  Copyright © 2025 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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
                overview:
                    "\"Star Wars™\" ist die größte Science-Fiction-Saga aller Zeiten, die mit ihren bislang neun filmischen Episoden und den unüberschaubaren Verzweigungen alle Dimensionen der Unterhaltungskultur gesprengt hat.",
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
