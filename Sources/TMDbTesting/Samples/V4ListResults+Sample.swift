//
//  V4ListResults+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension V4CreateListResult {

    /// A sample `V4CreateListResult` populated with representative data.
    static var sample: V4CreateListResult {
        V4CreateListResult(success: true, id: 8_678_999)
    }

}

public extension V4ClearListResult {

    /// A sample `V4ClearListResult` populated with representative data.
    static var sample: V4ClearListResult {
        V4ClearListResult(success: true, id: 8_678_999, itemsDeleted: 2)
    }

}

public extension V4ListItemResult {

    /// A sample `V4ListItemResult` for a movie that succeeded.
    static var sample: V4ListItemResult {
        V4ListItemResult(mediaType: .movie, mediaID: 550, success: true)
    }

    /// Sample `V4ListItemResult`s — one movie and one TV series.
    static var samples: [V4ListItemResult] {
        [
            V4ListItemResult(mediaType: .movie, mediaID: 550, success: true),
            V4ListItemResult(mediaType: .tvSeries, mediaID: 1399, success: true)
        ]
    }

}

public extension V4ListItemsResult {

    /// A sample `V4ListItemsResult` in which every item succeeded.
    static var sample: V4ListItemsResult {
        V4ListItemsResult(success: true, results: V4ListItemResult.samples)
    }

    /// A sample `V4ListItemsResult` showing the partial failure TMDb really
    /// returns: the request succeeded while an individual item did not.
    static var partialFailureSample: V4ListItemsResult {
        V4ListItemsResult(
            success: true,
            results: [
                V4ListItemResult(mediaType: .movie, mediaID: 550, success: false),
                V4ListItemResult(mediaType: .tvSeries, mediaID: 1399, success: true)
            ]
        )
    }

}

public extension V4ListMediaItem {

    /// A sample `V4ListMediaItem` for a movie.
    static var sample: V4ListMediaItem {
        .movie(550)
    }

    /// Sample `V4ListMediaItem`s — one movie and one TV series.
    static var samples: [V4ListMediaItem] {
        [.movie(550), .tvSeries(1399)]
    }

}

public extension V4ListItemComment {

    /// A sample `V4ListItemComment` for a movie.
    static var sample: V4ListItemComment {
        .movie(550, comment: "Rewatch for the twist")
    }

    /// Sample `V4ListItemComment`s.
    static var samples: [V4ListItemComment] {
        [
            .movie(550, comment: "Rewatch for the twist"),
            .tvSeries(1399, comment: "Start from season 1")
        ]
    }

}

public extension V4ListAttributes {

    /// A sample `V4ListAttributes` populated with representative data.
    static var sample: V4ListAttributes {
        V4ListAttributes(
            name: "My Watchlist",
            description: "Films and shows to catch up on",
            isPublic: true,
            languageCode: "en",
            countryCode: "US",
            sortBy: .originalOrder()
        )
    }

}
