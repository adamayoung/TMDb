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
            id: 63056,
            stills: [
                ImageMetadata(
                    filePath: URL(string: "/o4IX9Mm0kpLITVANJMx7inyEUaY.jpg")
                        ?? URL(fileURLWithPath: "/"),
                    width: 1920,
                    height: 1080,
                    aspectRatio: 1.778,
                    voteAverage: 10,
                    voteCount: 8,
                    languageCode: nil
                )
            ]
        )
    }

}
