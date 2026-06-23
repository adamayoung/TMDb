//
//  TVEpisodeImageCollection+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension TVEpisodeImageCollection {

    /// A sample `TVEpisodeImageCollection` for use in tests and previews.
    static var sample: TVEpisodeImageCollection {
        TVEpisodeImageCollection(
            id: 1,
            stills: [
                ImageMetadata(
                    filePath: URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg")
                        ?? URL(fileURLWithPath: "/"),
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
