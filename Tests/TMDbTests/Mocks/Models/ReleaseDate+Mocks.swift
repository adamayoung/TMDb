//
//  ReleaseDate+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@testable import TMDb

extension ReleaseDate {

    static func mock(
        certification: String = "R",
        descriptors: [String] = [],
        languageCode: String? = nil,
        note: String? = nil,
        releaseDate: Date = Date(timeIntervalSince1970: 939_945_600),
        type: ReleaseType = .theatrical
    ) -> ReleaseDate {
        ReleaseDate(
            certification: certification,
            descriptors: descriptors,
            languageCode: languageCode,
            note: note,
            releaseDate: releaseDate,
            type: type
        )
    }

}
