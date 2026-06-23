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
            id: 1,
            cast: [
                .movie(
                    MovieCastCredit(
                        id: 1,
                        title: "Movie name",
                        originalTitle: "Movie name",
                        originalLanguage: "en",
                        overview: "Movie Overview",
                        genreIDs: [28, 18],
                        releaseDate: Date(timeIntervalSince1970: 1_384_510_800),
                        posterPath: URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg"),
                        backdropPath: URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg"),
                        popularity: 5,
                        voteAverage: 6,
                        voteCount: 120,
                        hasVideo: false,
                        isAdultOnly: false,
                        character: "Character Name",
                        creditID: "credit123",
                        order: 0
                    )
                )
            ],
            crew: [
                .movie(
                    MovieCrewCredit(
                        id: 1,
                        title: "Movie name",
                        originalTitle: "Movie name",
                        originalLanguage: "en",
                        overview: "Movie Overview",
                        genreIDs: [28, 18],
                        releaseDate: Date(timeIntervalSince1970: 1_384_510_800),
                        posterPath: URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg"),
                        backdropPath: URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg"),
                        popularity: 5,
                        voteAverage: 6,
                        voteCount: 120,
                        hasVideo: false,
                        isAdultOnly: false,
                        job: "Director",
                        department: "Directing",
                        creditID: "credit123"
                    )
                )
            ]
        )
    }

}
