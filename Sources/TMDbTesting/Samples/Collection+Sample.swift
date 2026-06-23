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
            overview: "An epic space-opera theatrical film series.",
            posterPath: URL(string: "/22dj38IckjzEEUZwN1tPU5VJ1qq.jpg"),
            backdropPath: URL(string: "/qVPChlozQ1BP3svfHjiAdNneMGA.jpg"),
            parts: [
                MovieListItem(
                    id: 11,
                    title: "Star Wars",
                    originalTitle: "Star Wars",
                    originalLanguage: "en",
                    originCountry: ["US"],
                    overview: "A long time ago in a galaxy far, far away.",
                    genreIDs: [12, 28, 878],
                    releaseDate: Date(timeIntervalSince1970: 233_366_400),
                    posterPath: URL(string: "/6FfCtAuVAW8XJjZ7eWeLibRLWTw.jpg"),
                    backdropPath: URL(string: "/4iJfYYoQzZcONB9hNzg0J0wWyPH.jpg"),
                    popularity: 5.6,
                    voteAverage: 8.2,
                    voteCount: 18000,
                    hasVideo: false,
                    isAdultOnly: false
                )
            ]
        )
    }

}
