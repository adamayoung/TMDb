//
//  MediaListItem+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension MediaListItem {

    static func mock(
        id: Int = 986_056,
        mediaType: ShowType = .movie,
        title: String = "Thunderbolts*",
        originalTitle: String = "Thunderbolts*",
        originalLanguage: String = "en",
        overview: String =
            // swiftlint:disable:next line_length
            "After finding themselves ensnared in a death trap, seven disillusioned castoffs must embark on a dangerous mission that will force them to confront the darkest corners of their pasts.",
        genreIDs: [Genre.ID] = [28, 878, 12],
        releaseDate: Date? = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.date(from: "2025-04-30")
        }(),
        posterPath: URL? = URL(string: "/hqcexYHbiTBfDIdDWxrxPtVndBX.jpg"),
        backdropPath: URL? = URL(string: "/jYCyTdPfgT01IOJWDnnetr9RDX6.jpg"),
        popularity: Double? = 20.2419,
        voteAverage: Double? = 7.3,
        voteCount: Int? = 3092,
        hasVideo: Bool? = false,
        isAdultOnly: Bool? = false
    ) -> MediaListItem {
        MediaListItem(
            id: id,
            mediaType: mediaType,
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
            isAdultOnly: isAdultOnly
        )
    }

}
