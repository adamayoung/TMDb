//
//  TVSeriesCastCredit+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@testable import TMDb

extension TVSeriesCastCredit {

    static func mock(
        id: Int = 1,
        name: String = "TV Series name",
        originalName: String = "TV Series name",
        originalLanguage: String = "en",
        overview: String = "TV Series Overview",
        genreIDs: [Genre.ID] = [18, 10765],
        firstAirDate: Date? = Date(iso8601: "2020-01-15T10:20:00Z"),
        originCountries: [String] = ["US"],
        posterPath: URL? = URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg"),
        backdropPath: URL? = URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg"),
        popularity: Double? = 5,
        voteAverage: Double? = 7.5,
        voteCount: Int? = 200,
        isAdultOnly: Bool? = false,
        episodeCount: Int? = 10,
        character: String = "Character Name",
        creditID: String = "credit123"
    ) -> TVSeriesCastCredit {
        TVSeriesCastCredit(
            id: id,
            name: name,
            originalName: originalName,
            originalLanguage: originalLanguage,
            overview: overview,
            genreIDs: genreIDs,
            firstAirDate: firstAirDate,
            originCountries: originCountries,
            posterPath: posterPath,
            backdropPath: backdropPath,
            popularity: popularity,
            voteAverage: voteAverage,
            voteCount: voteCount,
            isAdultOnly: isAdultOnly,
            episodeCount: episodeCount,
            character: character,
            creditID: creditID
        )
    }

}

extension [TVSeriesCastCredit] {

    static var mocks: [TVSeriesCastCredit] {
        [
            .mock(id: 1, name: "TV Series 1", episodeCount: 10, character: "Character 1"),
            .mock(id: 2, name: "TV Series 2", episodeCount: 8, character: "Character 2"),
            .mock(id: 3, name: "TV Series 3", episodeCount: 12, character: "Character 3")
        ]
    }

}
