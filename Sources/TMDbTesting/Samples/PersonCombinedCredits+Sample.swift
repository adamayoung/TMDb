//
//  PersonCombinedCredits+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension PersonCombinedCredits {

    /// A sample `PersonCombinedCredits` populated with representative data.
    static var sample: PersonCombinedCredits {
        PersonCombinedCredits(
            id: 287,
            cast: [
                .movie(
                    MovieCastCredit(
                        id: 63,
                        title: "Twelve Monkeys",
                        originalTitle: "Twelve Monkeys",
                        originalLanguage: "en",
                        overview: """
                        In the year 2035, convict James Cole reluctantly volunteers to be \
                        sent back in time to discover the origin of a deadly virus that \
                        wiped out nearly all of the earth's population and forced the \
                        survivors into underground communities.
                        """,
                        genreIDs: [878, 53, 9648],
                        releaseDate: Date(timeIntervalSince1970: 820_195_200),
                        posterPath: URL(string: "/gt3iyguaCIw8DpQZI1LIN5TohM2.jpg"),
                        backdropPath: URL(string: "/mKIkGoyuR71qz6FdiEiOjxvBQcS.jpg"),
                        popularity: 6.6865,
                        voteAverage: 7.6,
                        voteCount: 9155,
                        hasVideo: false,
                        isAdultOnly: false,
                        character: "Jeffrey Goines",
                        creditID: "52fe4212c3a36847f8001b39",
                        order: 2
                    )
                )
            ],
            crew: [
                .movie(
                    MovieCrewCredit(
                        id: 1422,
                        title: "The Departed",
                        originalTitle: "The Departed",
                        originalLanguage: "en",
                        overview: """
                        To take down South Boston's Irish Mafia, the police send in one of \
                        their own to infiltrate the underworld, not realizing the syndicate \
                        has done likewise.
                        """,
                        genreIDs: [18, 53, 80],
                        releaseDate: Date(timeIntervalSince1970: 1_159_920_000),
                        posterPath: URL(string: "/nT97ifVT2J1yMQmeq20Qblg61T.jpg"),
                        backdropPath: URL(string: "/6WRrGYalXXveItfpnipYdayFkQB.jpg"),
                        popularity: 12.6671,
                        voteAverage: 8.16,
                        voteCount: 16263,
                        hasVideo: false,
                        isAdultOnly: false,
                        job: "Producer",
                        department: "Production",
                        creditID: "52fe42f5c3a36847f802ff41"
                    )
                )
            ]
        )
    }

}
