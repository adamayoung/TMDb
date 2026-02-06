//
//  Credit+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension Credit {

    static func mock(
        id: String = "52542282760ee313280017f9",
        creditType: CreditType = .cast,
        department: String = "Acting",
        job: String = "Actor",
        mediaType: String = "tv",
        media: CreditMedia = .tvSeries(.mock()),
        person: CreditPerson = .mock()
    ) -> Credit {
        Credit(
            id: id,
            creditType: creditType,
            department: department,
            job: job,
            mediaType: mediaType,
            media: media,
            person: person
        )
    }

    static var breakingBad: Credit {
        Credit.mock(
            id: "52542282760ee313280017f9",
            creditType: .cast,
            department: "Acting",
            job: "Actor",
            mediaType: "tv",
            media: .tvSeries(.breakingBad),
            person: .bryanCranston
        )
    }

}
