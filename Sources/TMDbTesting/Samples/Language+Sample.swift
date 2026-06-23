//
//  Language+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension Language {

    /// A sample `Language` for use in tests and previews.
    static var sample: Language {
        Language(code: "en", name: "English", englishName: "English")
    }

}

public extension [Language] {

    /// A sample array of `Language` values for use in tests and previews.
    static var samples: [Language] {
        [
            Language(code: "af", name: "Afrikaans", englishName: "Afrikaans"),
            Language(code: "hu", name: "Magyar", englishName: "Hungarian"),
            Language(code: "ga", name: "Gaeilge", englishName: "Irish"),
            Language(code: "en", name: "English", englishName: "English")
        ]
    }

}
