//
//  TVSeasonImageCollection+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension TVSeasonImageCollection {

    /// A sample `TVSeasonImageCollection` for use in tests and previews.
    static var sample: TVSeasonImageCollection {
        let posterPath1 = URL(string: "/nzuu9H5De0zL687q2gmXxN9tfEQ.jpg")
            ?? URL(fileURLWithPath: "/")
        let posterPath2 = URL(string: "/wgfKiqzuMrFIkU1M68DDDY8kGC1.jpg")
            ?? URL(fileURLWithPath: "/")

        return TVSeasonImageCollection(
            id: 3624,
            posters: [
                ImageMetadata(
                    filePath: posterPath1,
                    width: 1000,
                    height: 1500,
                    aspectRatio: 0.667,
                    voteAverage: 6.722,
                    voteCount: 6,
                    languageCode: "fr"
                ),
                ImageMetadata(
                    filePath: posterPath2,
                    width: 1000,
                    height: 1500,
                    aspectRatio: 0.667,
                    voteAverage: 6.38,
                    voteCount: 21,
                    languageCode: "en"
                )
            ]
        )
    }

}
