//
//  MediaList+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension MediaList {

    /// A sample `MediaList` populated with representative data.
    static var sample: MediaList {
        MediaList(
            id: 1,
            name: "The Marvel Universe",
            description: "The idea behind this list is to collect the live action "
                + "comic book movies from within the Marvel franchise.",
            createdBy: "Travis Bell",
            iso6391: "en",
            itemCount: 69,
            favoriteCount: 0,
            posterPath: URL(string: "/coJVIUEOToAEGViuhclM7pXC75R.jpg"),
            items: [],
            page: 1,
            totalPages: 4,
            totalResults: 69
        )
    }

}
