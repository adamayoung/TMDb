//
//  Language+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension Language {

    static func mock(
        code: String = "en",
        name: String = "English",
        englishName: String = "English"
    ) -> Language {
        Language(
            code: code,
            name: name,
            englishName: englishName
        )
    }

    static var african: Language {
        Language.mock(code: "af", name: "Afrikaans", englishName: "Afrikaans")
    }

    static var hungarian: Language {
        Language.mock(code: "hu", name: "Magyar", englishName: "Hungarian")
    }

    static var irish: Language {
        Language.mock(code: "ga", name: "Gaeilge", englishName: "Irish")
    }

    static var english: Language {
        Language.mock(code: "en", name: "English", englishName: "English")
    }

}

extension [Language] {

    static var mocks: [Language] {
        [.african, .hungarian, .irish, .english]
    }

}
