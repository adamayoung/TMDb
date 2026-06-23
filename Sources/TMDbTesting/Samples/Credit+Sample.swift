//
//  Credit+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension Credit {

    /// A sample `Credit` for use in tests and previews.
    static var sample: Credit {
        Credit(
            id: "52542282760ee313280017f9",
            creditType: .cast,
            department: "Acting",
            job: "Actor",
            mediaType: "tv",
            media: .tvSeries(
                CreditTVSeries(
                    id: 1396,
                    name: "Breaking Bad",
                    originalName: "Breaking Bad",
                    overview: "Walter White, a New Mexico chemistry teacher, is diagnosed with "
                        + "Stage III cancer and given a prognosis of only two years left to live.",
                    posterPath: nil,
                    backdropPath: nil,
                    popularity: 134.0744,
                    firstAirDate: nil,
                    voteAverage: 8.947,
                    voteCount: 17965,
                    character: "Walter White"
                )
            ),
            person: CreditPerson(
                id: 17419,
                name: "Bryan Cranston",
                originalName: "Bryan Cranston",
                gender: .male,
                knownForDepartment: "Acting",
                profilePath: URL(string: "/7Jahy5LZX2Fo8fGJltMreAI49hC.jpg"),
                popularity: 3.9034
            )
        )
    }

}
