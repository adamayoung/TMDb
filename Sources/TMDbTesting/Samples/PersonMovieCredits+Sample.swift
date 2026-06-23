//
//  PersonMovieCredits+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension PersonMovieCredits {

    /// A sample `PersonMovieCredits` for use in tests and previews.
    static var sample: PersonMovieCredits {
        PersonMovieCredits(
            id: 1,
            cast: [
                MovieCastCredit(
                    id: 1,
                    title: "Movie 1",
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
                    character: "Character 1",
                    creditID: "credit123",
                    order: 0
                )
            ],
            crew: [
                MovieCrewCredit(
                    id: 1,
                    title: "Movie 1",
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
            ]
        )
    }

}
