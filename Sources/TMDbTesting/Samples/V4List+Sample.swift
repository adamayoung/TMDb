//
//  V4List+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension V4ListCreator {

    /// A sample `V4ListCreator` populated with representative data.
    static var sample: V4ListCreator {
        V4ListCreator(
            id: "1a2b3c4d5e6f7a8b9c0d1e2f",
            name: "Test User",
            username: "testuser",
            avatarPath: URL(string: "/1AbCdEfGhIjKlMnOpQrStUvWxYz.jpg"),
            gravatarHash: "0123456789abcdef0123456789abcdef"
        )
    }

}

public extension V4ListItem {

    /// A sample `V4ListItem` — a movie, with a comment.
    static var sample: V4ListItem {
        V4ListItem(media: .movie(sampleMovie), comment: "Rewatch for the twist")
    }

    /// Sample `V4ListItem`s — one movie and one TV series, since holding both
    /// is what distinguishes a v4 list from a v3 one.
    static var samples: [V4ListItem] {
        [
            V4ListItem(media: .movie(sampleMovie), comment: "Rewatch for the twist"),
            V4ListItem(media: .tvSeries(sampleTVSeries), comment: nil)
        ]
    }

    private static var sampleMovie: MovieListItem {
        MovieListItem(
            id: 550,
            title: "Fight Club",
            originalTitle: "Fight Club",
            originalLanguage: "en",
            overview: """
            A ticking-time-bomb insomniac and a slippery soap salesman channel primal male \
            aggression into a shocking new form of therapy.
            """,
            genreIDs: [18, 53],
            releaseDate: Date(timeIntervalSince1970: 939_945_600),
            posterPath: URL(string: "/jSziioSwPVrOy9Yow3XhWIBDjq1.jpg"),
            backdropPath: URL(string: "/c6OLXfKAk5BKeR6broC8pYiCquX.jpg"),
            popularity: 54.7069,
            voteAverage: 8.437,
            voteCount: 32545,
            hasVideo: false,
            isAdultOnly: false
        )
    }

    private static var sampleTVSeries: TVSeriesListItem {
        TVSeriesListItem(
            id: 1399,
            name: "Game of Thrones",
            originalName: "Game of Thrones",
            originalLanguage: "en",
            overview: """
            Seven noble families fight for control of the mythical land of Westeros. Friction \
            between the houses leads to full-scale war.
            """,
            genreIDs: [10765, 18, 10759],
            firstAirDate: Date(timeIntervalSince1970: 1_303_084_800),
            originCountries: ["US"],
            posterPath: URL(string: "/1XS1oqL89opfnbLl8WnZY1O1uJx.jpg"),
            backdropPath: URL(string: "/2OMB0ynKlyIenMJWI2Dy9IWT4c.jpg"),
            popularity: 178.5243,
            voteAverage: 8.468,
            voteCount: 27430
        )
    }

}

public extension V4List {

    /// A sample `V4List` populated with representative data, holding both a
    /// movie and a TV series.
    static var sample: V4List {
        V4List(
            id: 8_678_999,
            name: "My Watchlist",
            description: "Films and shows to catch up on",
            isPublic: true,
            createdBy: .sample,
            items: V4ListItem.samples,
            itemCount: 2,
            averageRating: 8.45,
            runtime: 8433,
            revenue: 43_124_857_678,
            sortBy: "original_order.asc",
            languageCode: "en",
            countryCode: "US",
            page: 1,
            totalPages: 1,
            totalResults: 2
        )
    }

}

public extension V4ListSummary {

    /// A sample `V4ListSummary` populated with representative data.
    static var sample: V4ListSummary {
        V4ListSummary(
            id: 8_678_999,
            name: "My Watchlist",
            description: "Films and shows to catch up on",
            accountObjectID: "1a2b3c4d5e6f7a8b9c0d1e2f",
            numberOfItems: 2,
            isPublic: true,
            isAdult: false,
            isFeatured: false,
            runtime: 8433,
            averageRating: 8.45,
            revenue: 43_124_857_678,
            sortBy: 1,
            languageCode: "en",
            countryCode: "US",
            // 2026-08-06 23:26:00 UTC and four seconds later — the shape this
            // endpoint sends, as opposed to the day-precision dates on items.
            createdAt: Date(timeIntervalSince1970: 1_786_058_760),
            updatedAt: Date(timeIntervalSince1970: 1_786_058_764)
        )
    }

    /// Sample `V4ListSummary`s.
    static var samples: [V4ListSummary] {
        [.sample]
    }

}
