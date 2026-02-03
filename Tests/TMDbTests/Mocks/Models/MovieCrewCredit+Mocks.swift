//
//  MovieCrewCredit+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import TMDb

extension MovieCrewCredit {

    static func mock(
        id: Int = 1,
        title: String = "Movie name",
        originalTitle: String = "Movie name",
        originalLanguage: String = "en",
        overview: String = "Movie Overview",
        genreIDs: [Genre.ID] = [28, 18],
        releaseDate: Date? = Date(iso8601: "2013-11-15T10:20:00Z"),
        posterPath: URL? = URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg"),
        backdropPath: URL? = URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg"),
        popularity: Double? = 5,
        voteAverage: Double? = 6,
        voteCount: Int? = 120,
        hasVideo: Bool? = false,
        isAdultOnly: Bool? = false,
        job: String = "Director",
        department: String = "Directing",
        creditID: String = "credit123"
    ) -> MovieCrewCredit {
        MovieCrewCredit(
            id: id,
            title: title,
            originalTitle: originalTitle,
            originalLanguage: originalLanguage,
            overview: overview,
            genreIDs: genreIDs,
            releaseDate: releaseDate,
            posterPath: posterPath,
            backdropPath: backdropPath,
            popularity: popularity,
            voteAverage: voteAverage,
            voteCount: voteCount,
            hasVideo: hasVideo,
            isAdultOnly: isAdultOnly,
            job: job,
            department: department,
            creditID: creditID
        )
    }

}

extension [MovieCrewCredit] {

    static var mocks: [MovieCrewCredit] {
        [
            .mock(id: 1, title: "Movie 1", job: "Director", department: "Directing"),
            .mock(id: 2, title: "Movie 2", job: "Producer", department: "Production"),
            .mock(id: 3, title: "Movie 3", job: "Writer", department: "Writing")
        ]
    }

}
