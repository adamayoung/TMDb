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
                    overview: "Walter White, a New Mexico chemistry teacher.",
                    posterPath: nil,
                    backdropPath: nil,
                    popularity: 108.6266,
                    firstAirDate: nil,
                    voteAverage: 8.937,
                    voteCount: 17020,
                    character: "Walter White"
                )
            ),
            person: CreditPerson(
                id: 17419,
                name: "Bryan Cranston",
                originalName: "Bryan Cranston",
                gender: .male,
                knownForDepartment: "Acting",
                profilePath: URL(string: "/npIIZJGSrcJIJ6yHdmbqO6Jzo5I.jpg"),
                popularity: 7.1326
            )
        )
    }

}
