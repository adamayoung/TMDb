//
//  Collection+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension TMDb.Collection {

    /// A sample `Collection` for use in previews and tests.
    static var sample: TMDb.Collection {
        TMDb.Collection(
            id: 10,
            name: "Star Wars Collection",
            originalName: "Star Wars Collection",
            originalLanguage: "en",
            overview: """
            An epic space-opera theatrical film series, which depicts the adventures of various \
            characters "a long time ago in a galaxy far, far away…."
            """,
            posterPath: URL(string: "/pWVLFh4OuejTpUaDQbB1C4zoS2p.jpg"),
            backdropPath: URL(string: "/iY2ujEY2m68OTTlPFTiHub9joHS.jpg"),
            parts: [
                MovieListItem(
                    id: 11,
                    title: "Star Wars",
                    originalTitle: "Star Wars",
                    originalLanguage: "en",
                    originCountry: ["US"],
                    overview: """
                    Princess Leia is captured and held hostage by the evil Imperial forces in \
                    their effort to take over the galactic Empire. Venturesome Luke Skywalker \
                    and dashing captain Han Solo team together with the loveable robot duo R2-D2 \
                    and C-3PO to rescue the beautiful princess and restore peace and justice in \
                    the Empire.
                    """,
                    genreIDs: [12, 28, 878],
                    releaseDate: Date(timeIntervalSince1970: 233_366_400),
                    posterPath: URL(string: "/6FfCtAuVAW8XJjZ7eWeLibRLWTw.jpg"),
                    backdropPath: URL(string: "/3H94YlnYWVLKQKEnfTBKvrCmHmt.jpg"),
                    popularity: 20.7448,
                    voteAverage: 8.206,
                    voteCount: 22417,
                    hasVideo: false,
                    isAdultOnly: false
                )
            ]
        )
    }

}
