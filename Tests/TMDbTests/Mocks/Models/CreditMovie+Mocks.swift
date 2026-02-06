//
//  CreditMovie+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension CreditMovie {

    static func mock(
        id: Int = 550,
        title: String? = "Fight Club",
        originalTitle: String? = "Fight Club",
        overview: String? = "A movie overview.",
        posterPath: URL? = nil,
        backdropPath: URL? = nil,
        popularity: Double? = 50.0,
        releaseDate: Date? = nil,
        voteAverage: Double? = 8.4,
        voteCount: Int? = 25000,
        character: String? = "The Narrator"
    ) -> CreditMovie {
        CreditMovie(
            id: id,
            title: title,
            originalTitle: originalTitle,
            overview: overview,
            posterPath: posterPath,
            backdropPath: backdropPath,
            popularity: popularity,
            releaseDate: releaseDate,
            voteAverage: voteAverage,
            voteCount: voteCount,
            character: character
        )
    }

}
