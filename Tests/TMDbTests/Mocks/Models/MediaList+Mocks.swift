//
//  MediaList+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension MediaList {

    static func mock(
        id: Int = 1,
        name: String = "The Marvel Universe",
        description: String? =
            // swiftlint:disable:next line_length
            "The idea behind this list is to collect the live action comic book movies from within the Marvel franchise.",
        createdBy: String = "Travis Bell",
        iso6391: String = "en",
        itemCount: Int = 69,
        favoriteCount: Int = 0,
        posterPath: URL? = URL(string: "/coJVIUEOToAEGViuhclM7pXC75R.jpg"),
        items: [MediaListItem] = [],
        page: Int? = 1,
        totalPages: Int? = 4,
        totalResults: Int? = 69
    ) -> MediaList {
        MediaList(
            id: id,
            name: name,
            description: description,
            createdBy: createdBy,
            iso6391: iso6391,
            itemCount: itemCount,
            favoriteCount: favoriteCount,
            posterPath: posterPath,
            items: items,
            page: page,
            totalPages: totalPages,
            totalResults: totalResults
        )
    }

}
