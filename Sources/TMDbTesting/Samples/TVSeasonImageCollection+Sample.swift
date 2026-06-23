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
        let posterPath = URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg")
            ?? URL(fileURLWithPath: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg")

        return TVSeasonImageCollection(
            id: 1,
            posters: [
                ImageMetadata(
                    filePath: posterPath,
                    width: 100,
                    height: 100,
                    aspectRatio: 1,
                    voteAverage: 5,
                    voteCount: 100,
                    languageCode: "en"
                ),
                ImageMetadata(
                    filePath: posterPath,
                    width: 100,
                    height: 100,
                    aspectRatio: 1,
                    voteAverage: 5,
                    voteCount: 100,
                    languageCode: "en"
                )
            ]
        )
    }

}
