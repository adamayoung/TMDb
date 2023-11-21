//
//  SpokenLanguage+Mocks.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

import Foundation
import TMDb

extension SpokenLanguage {

    static func mocks(
        languageCode: String = .randomString,
        name: String = .randomString
    ) -> Self {
        .init(
            languageCode: languageCode,
            name: name
        )
    }

}

extension [SpokenLanguage] {

    static var mocks: [Element] {
        [.mocks(), .mocks(), .mocks()]
    }

}
