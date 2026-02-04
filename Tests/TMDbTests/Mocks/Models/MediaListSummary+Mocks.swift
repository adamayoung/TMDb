//
//  MediaListSummary+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension MediaListSummary {

    static func mock(
        id: Int = 1,
        name: String = "Test List",
        description: String? = "Test Description",
        itemCount: Int = 10,
        favoriteCount: Int = 5,
        iso6391: String? = "en",
        iso31661: String? = "US",
        listType: String = "movie",
        posterPath: URL? = URL(string: "/poster.jpg")
    ) -> MediaListSummary {
        MediaListSummary(
            id: id,
            name: name,
            description: description,
            itemCount: itemCount,
            favoriteCount: favoriteCount,
            iso6391: iso6391,
            iso31661: iso31661,
            listType: listType,
            posterPath: posterPath
        )
    }

}

extension [MediaListSummary] {

    static var mocks: [MediaListSummary] {
        [
            .mock(id: 1, name: "List 1"),
            .mock(id: 2, name: "List 2"),
            .mock(id: 3, name: "List 3")
        ]
    }

}
