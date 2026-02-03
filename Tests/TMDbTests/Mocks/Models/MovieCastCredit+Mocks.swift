//
//  MovieCastCredit+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import TMDb

extension MovieCastCredit {

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
        character: String = "Character Name",
        creditID: String = "credit123",
        order: Int = 0
    ) -> MovieCastCredit {
        MovieCastCredit(
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
            character: character,
            creditID: creditID,
            order: order
        )
    }

}

extension [MovieCastCredit] {

    static var mocks: [MovieCastCredit] {
        [
            .mock(id: 1, title: "Movie 1", character: "Character 1", order: 0),
            .mock(id: 2, title: "Movie 2", character: "Character 2", order: 1),
            .mock(id: 3, title: "Movie 3", character: "Character 3", order: 2)
        ]
    }

}
