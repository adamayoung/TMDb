//
//  SpokenLanguage+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

package extension SpokenLanguage {

    static func mock(
        languageCode: String = "en",
        name: String = "English"
    ) -> SpokenLanguage {
        SpokenLanguage(
            languageCode: languageCode,
            name: name
        )
    }

}

package extension [SpokenLanguage] {

    static var mocks: [SpokenLanguage] {
        [.mock(), .mock(), .mock()]
    }

}
