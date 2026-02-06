//
//  CreditTVSeries+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension CreditTVSeries {

    static func mock(
        id: Int = 1396,
        name: String? = "Breaking Bad",
        originalName: String? = "Breaking Bad",
        overview: String? = "Walter White, a New Mexico chemistry teacher.",
        posterPath: URL? = nil,
        backdropPath: URL? = nil,
        popularity: Double? = 108.6266,
        firstAirDate: Date? = nil,
        voteAverage: Double? = 8.937,
        voteCount: Int? = 17020,
        character: String? = "Walter White"
    ) -> CreditTVSeries {
        CreditTVSeries(
            id: id,
            name: name,
            originalName: originalName,
            overview: overview,
            posterPath: posterPath,
            backdropPath: backdropPath,
            popularity: popularity,
            firstAirDate: firstAirDate,
            voteAverage: voteAverage,
            voteCount: voteCount,
            character: character
        )
    }

    static var breakingBad: CreditTVSeries {
        CreditTVSeries.mock()
    }

}
